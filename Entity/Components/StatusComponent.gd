extends EntityComponent
class_name StatusComponent
## Applies status to the entity and holds a list of current status.


var current_on_turn_start_status: Array[StatusBase] = []
var current_on_apply_status: Array[StatusBase] = []

func _select_storing_array_for_status(status: StatusBase) -> Array[StatusBase]:
	if status.is_on_apply:
		return current_on_apply_status
	else:
		return current_on_turn_start_status


func add_status(new_status: StatusBase, status_caster: Entity) -> void:
	# duplicate the status so we aren't modifying the base
	var status_copy: StatusBase = new_status.duplicate()
	var array_to_store_status: Array[StatusBase] = _select_storing_array_for_status(new_status)
	
	# see if the status was already applied. If so, add to the duration instead of applying
	var found_status = Helpers.find_first_from_array_by_type(array_to_store_status, status_copy.get_script())
	if found_status != null:
		found_status.status_turn_duration += status_copy.status_turn_duration
		if found_status.status_power != status_copy.status_power:
			found_status.status_power = status_copy.status_power
			# this is a design choice, we choose that if a status has changed its powwer
			# then we keep the number of turns and use the new power
	
	# we don't have this status, add it as new
	else:
		array_to_store_status.append(status_copy)
		
		assert(entity_owner != null, "statusComponent has no owner. Please call init on Entity.")
		
		status_copy.init_status(entity_owner, status_caster)
		if status_copy.is_on_apply:
			status_copy.on_apply()


func remove_status(new_status: StatusBase) -> void:
	new_status.on_remove()
	var status_index: int = current_on_turn_start_status.find(new_status)
	current_on_turn_start_status.remove_at(status_index)


func apply_turn_start_status() -> void:
	for status: StatusBase in current_on_turn_start_status:
		status.on_turn_start()
		
		# remove status if turn duration is depleted
		if not status.infinite_duration:
			status.status_turn_duration -= 1
			if status.status_turn_duration <= 0:
				remove_status(status)
