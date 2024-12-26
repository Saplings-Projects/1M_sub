extends EntityComponent
class_name BehaviorComponent
## Controls the way enemies behave during a fight.
##
## TODO: right now this just holds a single attack. In the future, we can have this component control the AI decision making for the enemy.
## 


## The attack that the enemy will do
@export var attack: CardBase = null
@export var overstress_attack: CardBase = null

## The attack set of the enemy
@export var enemy_attack_tree: EnemyActionTree

func _ready() -> void:
	if enemy_attack_tree == null:
		# give default action tree if no action tree is already set
		enemy_attack_tree = EnemyActionTree.new()
	
	
func get_attack(stress_component: StressComponent) -> CardBase:
	if stress_component.has_hit_overstress:
		return stress_component.on_overstress()
	else:
		return enemy_attack_tree.choose_next_action()
