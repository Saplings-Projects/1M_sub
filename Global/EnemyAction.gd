extends RefCounted

class_name EnemyAction

var _caster: Entity
var _action: CardBase
var _target_list: Array[Entity]
	
func _init(caster: Entity, action: CardBase, target_list: Array[Entity]):
	self._caster = caster
	self._action = action
	self._target_list = target_list
	
# function to attack that plays card
func execute() -> void:
	if not is_instance_valid(_caster):
		print("Caster died, skipping action")
		return
	
	# Simplified for now, will need refactor once we have advanced enemy actions
	if not is_instance_valid(_target_list[0]) or _target_list[0].get_health_component().current_health == 0: 
		print("Target died, skipping action")
		return
		
	var can_execute: bool = _action.can_play_card(_caster, _target_list[0])
	assert(can_execute == true, "Enemy failed to attack.")
	
	if can_execute:
		_action.on_card_play(_caster, _target_list)
