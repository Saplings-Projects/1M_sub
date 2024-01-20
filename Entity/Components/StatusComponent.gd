extends EntityComponent
class_name StatusComponent
## Applies status to the entity and holds a list of current status.


var current_status: Array[StatusBase] = []

# func _select_storing_array_for_status(status: StatusBase) -> Array[StatusBase]:
# 	if status.is_on_apply:
# 		return current_on_apply_status
# 	else:
# 		return current_on_turn_start_status


func add_status(new_status: StatusBase, status_caster: Entity) -> void:
	# duplicate the status so we aren't modifying the base
	var status_copy: StatusBase = new_status.duplicate()
	
	# see if the status was already applied. If so, add to the duration instead of applying
	var found_status = Helpers.find_first_from_array_by_type(current_status, status_copy.get_script())
	
	assert(entity_owner != null, "statusComponent has no owner. Please call init on Entity.")
	status_copy.init_status(status_caster, entity_owner)
	
	if found_status != null:
		found_status.status_turn_duration += status_copy.status_turn_duration
		if found_status.status_power != status_copy.status_power:
			found_status.status_power = status_copy.status_power
			# this is a design choice, we choose that if a status has changed its powwer
			# then we keep the number of turns and use the new power
	
	# we don't have this status, add it as new
	else:
		current_status.append(status_copy)
		
		if status_copy.is_on_apply:
			status_copy.on_apply()


func remove_status(new_status: StatusBase) -> void:
	var found_status: StatusBase = Helpers.find_first_from_array_by_type(current_status, new_status.get_script())
	found_status.on_remove()
	current_status.erase(found_status)


func apply_turn_start_status() -> void:
	for status: StatusBase in current_status:
		if status.is_on_turn_start:
			status.on_turn_start()
		
		# remove status if turn duration is depleted
		if not status.infinite_duration:
			status.status_turn_duration -= 1
			if status.status_turn_duration <= 0:
				remove_status(status)

func remove_all_status() -> void:
	for status: StatusBase in current_status:
		status.on_remove()
		# can't use remove_status here because it will modify the array we are iterating over
	current_status.clear()
