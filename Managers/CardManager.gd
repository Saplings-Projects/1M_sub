extends Node
## Global AutoLoaded class that allows you to get the card container from anywhere.


signal on_card_container_initialized

var card_container: CardContainer = null


func set_card_container(in_card_container: CardContainer):
	card_container = in_card_container
	on_card_container_initialized.emit()
