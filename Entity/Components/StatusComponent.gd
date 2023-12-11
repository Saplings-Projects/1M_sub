extends EntityComponent
class_name StatusComponent
## Applies status to the entity and holds a list of current status.


var current_status: Array[StatusBase]


func add_status(new_status: StatusBase, status_applier: Entity) -> void:
	# duplicate the status so we aren't modifying the base
	var status_copy: StatusBase = new_status.duplicate()
	
	# see if the status was already applied. If so, add to the duration instead of applying
	var found_status = Helpers.find_first_from_array_by_type(current_status, status_copy.get_script())
	if found_status != null:
		found_status.status_turn_duration += status_copy.status_turn_duration
	
	# we don't have this status, add it as new
	else:
		current_status.append(status_copy)
		
		assert(entity_owner != null, "statusComponent has no owner. Please call init on Entity.")
		
		status_copy.init_status(entity_owner, status_applier)


func remove_status(new_status: StatusBase) -> void:
	var status_index: int = current_status.find(new_status)
	current_status.remove_at(status_index)


func apply_turn_start_status() -> void:
	for status: StatusBase in current_status:
		status.on_turn_start()
		
		# remove status if turn duration is depleted
		if not status.infinite_duration:
			status.status_turn_duration -= 1
			if status.status_turn_duration <= 0:
				remove_status(status)
