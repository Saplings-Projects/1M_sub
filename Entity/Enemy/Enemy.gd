extends Entity
class_name Enemy
## Base enemy class.

## @Override [br]
## See [Entity] for more information [br]
## Connect the enemy to the [PhaseManager] to make it attack when it's its turn.
func _ready() -> void:
	super()
	PhaseManager.on_phase_changed.connect(_on_phase_changed)


## Only allow the player to interact with enemies when it's the player turn
func _on_phase_changed(new_phase: GlobalEnums.Phase, _old_phase: GlobalEnums.Phase) -> void:
	get_click_handler().set_interactable(new_phase == GlobalEnums.Phase.PLAYER_ATTACKING)

## Used to get the enemy AI [br]
## Not in [Entity] as this is specific to enemies
func get_behavior_component() -> BehaviorComponent:
	return Helpers.get_first_child_node_of_type(self, BehaviorComponent) as BehaviorComponent
