extends Control
class_name CardUISetter
## Handles setting up UI on a card by pulling from CardBase stats.
##
## The idea with using a UI setter like this is we don't have any references to UI stuff
## in the actual Card class, so we can keep that class as minimal as possible.


@export var title_label: Label
@export var description_label: Label
@export var key_art: TextureRect


func _ready() -> void:
	var parent_card: CardWorld = get_parent() as CardWorld
	
	assert(parent_card != null, "Couldn't find parent card. Make sure this is attached to a card.")
	
	# wait for stats to initialize if needed
	if parent_card.stats != null:
		_stats_initialized(parent_card.stats)
	else:
		parent_card.on_card_stats_initialized.connect(_stats_initialized)


func _stats_initialized(in_stats: CardBase) -> void:
	title_label.text = in_stats.card_title
	description_label.text = in_stats.card_description
	if in_stats.card_key_art:
		key_art.texture = in_stats.card_key_art
	else:
		push_warning("No key art set in the card stats. Using default")
