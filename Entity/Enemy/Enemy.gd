extends Entity
class_name Enemy
## Base enemy entity class.

# @Override
func _ready() -> void:
	super()
	PhaseManager.on_phase_changed.connect(_on_phase_changed)


func _on_phase_changed(new_phase: GlobalEnum.Phase, _old_phase: GlobalEnum.Phase) -> void:
	get_click_handler().set_interactable(new_phase == GlobalEnum.Phase.PLAYER_ATTACKING)


func get_behavior_component() -> BehaviorComponent:
	return Helpers.get_first_child_node_of_type(self, BehaviorComponent) as BehaviorComponent
