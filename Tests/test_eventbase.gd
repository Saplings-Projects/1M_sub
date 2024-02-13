extends GutTest
## Test for Event Base and Events

var eventBase: EventBase = null

func before_each() -> void:
	eventBase = EventBase.new()

func after_each() -> void:
	assert_no_new_orphans("Orphans still exist, please free up test resources.")

func test_event_base_array_all_types() -> void:
	var event0: EventBase = eventBase.EVENTS_CLASSIFICATION[0]
	assert_eq(event0, EventMob)
	
	var event1: EventBase = eventBase.EVENTS_CLASSIFICATION[1]
	assert_eq(event1, EventRandom)
	
	var event2: EventBase = eventBase.EVENTS_CLASSIFICATION[2]
	assert_eq(event2, EventShop)
	
	var event3: EventBase = eventBase.EVENTS_CLASSIFICATION[3]
	assert_eq(event3, EventHeal)

