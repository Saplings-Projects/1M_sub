extends RefCounted

class_name EnemyAction
## ? is this needed anymore
## ? does it need to be global
## ? what is the link with the behaviour component

var caster: Entity
var action: CardBase
var target: Entity
	
func _init(_caster: Entity, _action: CardBase, _target: Entity) -> void:
	self.caster = _caster
	self.action = _action
	self.target = _target
	
# function to attack that plays card
func execute() -> void:
	if not is_instance_valid(caster):
		print("Caster died, skipping action")
		return
	
	# Simplified for now, will need refactor once we have advanced enemy actions
	if not is_instance_valid(target) or target.get_health_component().current_health == 0: 
		print("Target died, skipping action")
		return
		
	var can_execute: bool = action.can_play_card(caster, target)
	assert(can_execute == true, "Enemy failed to attack.")
	
	if can_execute:
		action.on_card_play(caster, target)
