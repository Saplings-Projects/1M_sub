extends TestBase

var card: CardBase

# @overide
func before_each():
	super()
	_player_energy_component.ignore_cost = false
	_player_energy_component.energy = 0
	_player_energy_component.energy_generation = 3
	_player_energy_component.Max_energy = 4

func test_add_energy():
	card = load("res://Cards/Resource/Card_Energy.tres") # adds 70 energy

	card.on_card_play(_player, [_player])
	assert_eq(_player_energy_component.energy, 70)


func test_using_energy():
	_player_energy_component.add_energy(10)
	card = load("res://Cards/Resource/Card_Damage.tres") # costs 7 by default
	card.energy.energy_cost = 7

	card.on_card_play(PlayerManager.player, [_enemy])

	assert_eq(_player_energy_component.energy, 3)

func test_no_energy():

	_card_container.draw_cards(1)

	var _queued_card: CardWorld = _card_container.cards_in_hand[0]
	_queued_card.card_data.energy.energy_cost = 999

	_card_container._on_card_clicked(_queued_card)

	assert_false(_card_container.is_card_queued())

func test_having_energy():

	_player_energy_component.add_energy(10)
	_card_container.draw_cards(1)

	var _queued_card: CardWorld = _card_container.cards_in_hand[0]
	_queued_card.card_data.energy.energy_cost = 9

	_card_container._on_card_clicked(_queued_card)

	assert_true(_card_container.is_card_queued())

func test_energy_generation():

	assert_eq(_player_energy_component.energy, 0)
	_player_energy_component.on_turn_end()

	assert_eq(_player_energy_component.energy, 3)
	_player_energy_component.on_turn_end()

	assert_eq(_player_energy_component.energy, 4)