extends GutTest
## Test for Event Base and Events

var eventBase: EventBase = null

func before_each() -> void:
	eventBase = EventBase.new()

func after_each() -> void:
	assert_no_new_orphans("Orphans still exist, please free up test resources.")

func test_event_base_array_all_types() -> void:
	var event0: Resource = GlobalVar.EVENTS_CLASSIFICATION[0]
	assert_eq(event0, EventRandom)
	
	var event1: Resource = GlobalVar.EVENTS_CLASSIFICATION[1]
	assert_eq(event1, EventHeal)
	
	var event2: Resource = GlobalVar.EVENTS_CLASSIFICATION[2]
	assert_eq(event2, EventMob)
	
	var event3: Resource = GlobalVar.EVENTS_CLASSIFICATION[3]
	assert_eq(event3, EventShop)

