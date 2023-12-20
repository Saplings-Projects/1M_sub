extends GutTest
## Test for Event Base and Events

var eventBase: EventBase = null

func before_each():
	eventBase = EventBase.new()

func test_event_base_array_all_types():
	var event0 = eventBase.EVENTS_CLASSIFICATION[0]
	assert_eq(event0, EventMob)
	
	var event1 = eventBase.EVENTS_CLASSIFICATION[1]
	assert_eq(event1, EventRandom)
	
	var event2 = eventBase.EVENTS_CLASSIFICATION[2]
	assert_eq(event2, EventShop)
	
	var event3 = eventBase.EVENTS_CLASSIFICATION[3]
	assert_eq(event3, EventHeal)

