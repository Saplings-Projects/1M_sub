extends Node
class_name CardPileUISetter


@export var pile_count_label: Label = null


func _ready() -> void:
	if CardManager.card_container != null:
		_on_card_container_initialized()
	else:
		CardManager.on_card_container_initialized.connect(_on_card_container_initialized)


func _on_card_container_initialized():
	CardManager.card_container.on_card_counts_updated.connect(_on_card_counts_updated)


func _on_card_counts_updated():
	pile_count_label.text = str(_get_count())


func _get_count() -> int:
	return CardManager.card_container.get_draw_pile_size()
