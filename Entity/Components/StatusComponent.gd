extends EntityComponent
class_name StatusComponent
## Globally loaded component that handles status on an entity
##
## This holds a list of all the status, and allows to add or remove status [br]
## It also handles applying effect of status at turn start
## Status that are "on apply" are handled separately, see [StatusBase]


## List of all the status currently applied on the entity
var current_status: Array[StatusBase] = []


func _ready() -> void:
	PhaseManager.on_event_win.connect(remove_all_status)


## Add a new status to the entity [br]
## The status caster is the one applying the status. [br]
## If the target entity already has the status, the duration of the new status is added to the existing one. [br]
func add_status(new_status: StatusBase, status_caster: Entity) -> void:
	# duplicate the status so we aren't modifying the base
	var status_copy: StatusBase = new_status.duplicate()
	
	# see if the status was already applied. If so, add to the duration instead of applying
	var found_status: StatusBase = Helpers.find_first_from_array_by_type(current_status, status_copy.get_script())
	
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


## This is only used in tests
## Remove a status from the entity [br]
## This is used if the status is removed by an effect [br]
## Removing a status due to its duration being depleted is handled by apply_turn_start_status [br]
## Eventually applies the on_remove effect of the status [br]
## @deprecated
func remove_status(new_status: StatusBase) -> void:
	var found_status: StatusBase = Helpers.find_first_from_array_by_type(current_status, new_status.get_script())
	found_status.on_remove()
	current_status.erase(found_status)


## For each status on the entity, if it's a status that has an effect at turn start (like poison), apply it [br]
## Also reduce the duration of every status by 1, removing them if their duration is depleted.
func apply_turn_start_status() -> void:
	var status_to_keep: Array[StatusBase] = []
	for status: StatusBase in current_status:
		if status.is_on_turn_start:
			status.on_turn_start()
		
		# only keep status if their duration is not depleted
		if not status.infinite_duration:
			status.status_turn_duration -= 1
			if status.status_turn_duration <= 0:
				status.on_remove()
			else:
				# * we can't remove the status as we are iterating over it
				# so we create a list of the status that are to keep
				status_to_keep.append(status) 
	current_status = status_to_keep

## Remove all status from the entity [br]
## Also applies the eventual on_remove effect of the status
func remove_all_status() -> void:
	for status: StatusBase in current_status:
		status.on_remove()
		# can't use remove_status here because it will modify the array we are iterating over
	current_status.clear()
