extends GutTest
## Test for Event Base and Events

var eventBase: EventBase = null

func before_each() -> void:
	eventBase = EventBase.new()

func after_each() -> void:
	assert_no_new_orphans("Orphans still exist, please free up test resources.")

func test_event_base_array_all_types() -> void:
	var event0: Resource = GlobalEnums.choose_event_from_type(GlobalEnums.EventType.Random)
	assert_true(event0 is EventRandom)
	
	var event1: Resource = GlobalEnums.choose_event_from_type(GlobalEnums.EventType.Heal)
	assert_true(event1 is EventHeal)
	
	var event2: Resource = GlobalEnums.choose_event_from_type(GlobalEnums.EventType.Mob)
	assert_true(event2 is EventMob)
	
	var event3: Resource = GlobalEnums.choose_event_from_type(GlobalEnums.EventType.Shop)
	assert_true(event3 is EventShop)
	
	var event4: Resource = GlobalEnums.choose_event_from_type(GlobalEnums.EventType.Dialogue)
	assert_true(event4 is EventDialogue)

