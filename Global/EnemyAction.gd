extends RefCounted

class_name EnemyAction

var caster: Entity
var action: CardBase
var target_list: Array[Entity]
	
func _init(_caster: Entity, _action: CardBase, _target_list: Array[Entity]) -> void:
	self.caster = _caster
	self.action = _action
	self.target_list = _target_list
	
# function to attack that plays card
func execute() -> void:
	if not is_instance_valid(caster):
		print("Caster died, skipping action")
		return
	
	# Simplified for now, will need refactor once we have advanced enemy actions
	if not is_instance_valid(target_list[0]) or target_list[0].get_health_component().current_health == 0: 
		print("Target died, skipping action")
		return
		
	var can_execute: bool = action.can_play_card(caster, target_list[0])
	assert(can_execute == true, "Enemy failed to attack.")
	
	if can_execute:
		action.on_card_play(caster, target_list)
