extends GutTest
## Test for Event Base and Events

var eventBase: EventBase = null

func before_each():
	eventBase = EventBase.new()

func after_each():
	assert_no_new_orphans("Orphans still exist, please free up test resources.")

func test_event_base_array_all_types():
	var event0 = GlobalVar.EVENTS_CLASSIFICATION[0]
	assert_eq(event0, EventMob)
	
	var event1 = GlobalVar.EVENTS_CLASSIFICATION[1]
	assert_eq(event1, EventRandom)
	
	var event2 = GlobalVar.EVENTS_CLASSIFICATION[2]
	assert_eq(event2, EventShop)
	
	var event3 = GlobalVar.EVENTS_CLASSIFICATION[3]
	assert_eq(event3, EventHeal)

