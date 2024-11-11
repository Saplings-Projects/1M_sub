extends Node
## Manager class for the shop

## price for card removal at the shop events
var card_removal_price : int = 50
var card_remocal_price_increase : int = 25

## the item pools for the various things provided in the shop[br]
## the items are loaded when taken so all that is needed here are strings to the items
var shop_card_pool : Array = ["res://Cards/Resource/Card_Damage.tres", "res://Cards/Resource/Card_DamageAllEnemies.tres"]
var shop_relic_pool : Array = ["res://Items/test_relic.tres", "res://Items/test_relic_2.tres"]
var shop_consumable_pool : Array = ["res://Items/test_consumable.tres","res://Items/test_consumable_2.tres"]

func increase_removal_price() -> void:
	card_removal_price += card_remocal_price_increase


## Removes given card, takes money, and increases shop prices. Should only be used by the shop removal[br]
## or potentionaly a specific event
func remove_card_from_player_deck_with_price(card : CardBase) -> void:
	CardManager.current_deck.erase(card)
	InventoryManager.gold_component.lose_gold(card_removal_price)
	increase_removal_price()

## Should be used any time card should be removed from deck
func remove_card_from_player_deck_without_price(card : CardBase) -> void:
	CardManager.current_deck.erase(card)
