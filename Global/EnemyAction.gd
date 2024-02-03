extends RefCounted

class_name EnemyAction

var caster: Entity
var action: CardBase
var target: Array[Entity]
	
func _init(caster: Entity, action: CardBase, target: Array[Entity]):
	self.caster = caster
	self.action = action
	self.target = target
	
# function to attack that plays card
func execute() -> void:
	if not is_instance_valid(self.caster):
		print("Caster died, skipping action")
		return
	
	# Simplified for now, will need refactor once we have advanced enemy actions
	if not is_instance_valid(self.target[0]) or self.target[0].get_health_component().current_health == 0: 
		print("Target died, skipping action")
		return
		
	var can_execute: bool = self.action.can_play_card(caster, target[0])
	assert(can_execute == true, "Enemy failed to attack.")
	
	if can_execute:
		self.action.on_card_play(caster, target)
