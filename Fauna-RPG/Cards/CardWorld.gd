extends Node2D
class_name CardWorld
## Card object that exists in the world. Not to be confused with CardBase,
## which holds a card's data.


signal on_card_stats_initialized(stats: CardBase)

var stats: CardBase = null


func _ready() -> void:
	PhaseManager.on_phase_changed.connect(_on_phase_changed)


func init_card(in_stats: CardBase) -> void:
	stats = in_stats
	on_card_stats_initialized.emit(stats)


func _on_phase_changed(new_phase: Enums.Phase, _old_phase: Enums.Phase) -> void:
	# enable clicks on card only if player is in attack phase
	var click_handler := Helpers.get_child_node_of_type(self, ClickHandler) as ClickHandler
	click_handler.set_interactable(new_phase == Enums.Phase.PLAYER_ATTACKING)


func get_lerp_component() -> LerpComponent:
	return Helpers.get_child_node_of_type(self, LerpComponent) as LerpComponent


func get_click_handler() -> ClickHandler:
	return Helpers.get_child_node_of_type(self, ClickHandler) as ClickHandler
