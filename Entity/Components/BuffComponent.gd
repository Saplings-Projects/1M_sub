extends EntityComponent
class_name BuffComponent
## Applies buffs to the entity and holds a list of current buffs.


var current_buffs: Array[BuffBase]


func add_buff(new_buff: BuffBase, buff_applier: Entity) -> void:
	# duplicate the buff so we aren't modifying the base
	var buff_copy: BuffBase = new_buff.duplicate()
	
	# see if the buff was already applied. If so, add to the duration instead of applying
	var found_buff = Helpers.find_first_from_array_by_type(current_buffs, buff_copy.get_script())
	if found_buff != null:
		found_buff.buff_turn_duration += buff_copy.buff_turn_duration
	
	# we don't have this buff, add it as new
	else:
		current_buffs.append(buff_copy)
		
		assert(entity_owner != null, "BuffComponent has no owner. Please call init on Entity.")
		
		buff_copy.init_buff(entity_owner, buff_applier)


func remove_buff(new_buff: BuffBase) -> void:
	var buff_index: int = current_buffs.find(new_buff)
	current_buffs.remove_at(buff_index)


func apply_turn_start_buffs() -> void:
	for buff: BuffBase in current_buffs:
		buff.on_turn_start()
		
		# remove buff if turn duration is depleted
		if not buff.infinite_duration:
			buff.buff_turn_duration -= 1
			if buff.buff_turn_duration <= 0:
				remove_buff(buff)
