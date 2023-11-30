extends Node
## Global AutoLoaded class that allows you to get the currently queued card from anywhere.
##
## TODO could potentially use this for global drawing of cards.


signal successful_card_play(card : CardWorld)

var queued_card : CardWorld = null


func is_card_queued():
	return queued_card != null


func set_queued_card(card : CardWorld):
	if card == null:
		queued_card = null
	else:
		queued_card = card


func notify_successful_play():
	successful_card_play.emit(queued_card)
	set_queued_card(null)
