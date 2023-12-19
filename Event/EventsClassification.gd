extends Node

enum EventsClassification { EVENT_MOB, EVENT_RANDOM, EVENT_SHOP, EVENT_HEAL }

func createEvent(index: int) -> Event:
	var event = null
	match index:
		EventsClassification.EVENT_MOB:
			event = Event_Mob.new("res://Event/EventTest.tscn")
		EventsClassification.EVENT_RANDOM:
			event = Event_Random.new("res://Event/EventTest.tscn")
		EventsClassification.EVENT_SHOP:
			event = Event_Shop.new("res://Event/EventTest.tscn")
		EventsClassification.EVENT_HEAL:
			event = Event_Heal.new("res://Event/EventTest.tscn")
	return event
