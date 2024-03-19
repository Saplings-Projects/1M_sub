extends TestBase


var created_cast_nodes: Array[Variant] = []


# @Override
func before_each() -> void:
	super()
	CardManager.disable_card_animations = false


func after_each() -> void:
	super()
	created_cast_nodes.clear()


func test_player_animation_created() -> void:
	var card: CardBase = CardBase.new()
	var cast_anim: CastAnimationData = CastAnimationData.new()
	cast_anim.cast_animation_scene = load("res://Cards/Animation/Anim_Slap.tscn")
	cast_anim.cast_position = CastPos_Caster.new()
	
	card.application_type = GlobalEnums.ApplicationType.ENEMY_ONLY
	card.card_effects_data.append(EffectData.new())
	card.card_effects_data[0].animation_data = cast_anim
	card.card_effects_data[0].targeting_function = TargetingBase.new()
	card.card_effects_data[0].effect = EffectDamage.new()
	
	card.on_card_play(_player, _enemy)
	
	# Animation should have been created as a child of the player
	created_cast_nodes = Helpers.get_all_children_nodes_of_type(_player, CastAnimation)
	
	assert_eq(created_cast_nodes.size(), 1)


func test_enemy_animation_created() -> void:
	var card: CardBase = CardBase.new()
	var cast_anim: CastAnimationData = CastAnimationData.new()
	cast_anim.cast_animation_scene = load("res://Cards/Animation/Anim_Slap.tscn")
	cast_anim.cast_position = CastPos_Caster.new()
	
	card.application_type = GlobalEnums.ApplicationType.FRIENDLY_ONLY
	card.card_effects_data.append(EffectData.new())
	card.card_effects_data[0].animation_data = cast_anim
	card.card_effects_data[0].targeting_function = TargetingBase.new()
	card.card_effects_data[0].effect = EffectDamage.new()
	
	card.on_card_play(_enemy, _player)
	
	# Animation should have been created as a child of the enemy
	created_cast_nodes = Helpers.get_all_children_nodes_of_type(_enemy, CastAnimation)
	
	assert_eq(created_cast_nodes.size(), 1)


func test_cast_position_all() -> void:
	# Create CardBase with CastPos_AllTargets and ensure one is created for each target
	var card: CardBase = CardBase.new()
	var cast_anim: CastAnimationData = CastAnimationData.new()
	cast_anim.cast_animation_scene = load("res://Cards/Animation/Anim_Slap.tscn")
	cast_anim.cast_position = CastPos_AllTargets.new()
	
	card.application_type = GlobalEnums.ApplicationType.ENEMY_ONLY
	card.card_effects_data.append(EffectData.new())
	card.card_effects_data[0].animation_data = cast_anim
	card.card_effects_data[0].targeting_function = TargetAllEnemies.new()
	card.card_effects_data[0].effect = EffectDamage.new()
	
	card.on_card_play(_player, _enemy)
	
	# CastPos_AllTargets should create an animation for all enemies
	var created_cast_nodes_enemy_1: Array[Variant] = Helpers.get_all_children_nodes_of_type(_enemy, CastAnimation)
	assert_eq(created_cast_nodes_enemy_1.size(), 1)
	var created_cast_nodes_enemy_2: Array[Variant] = Helpers.get_all_children_nodes_of_type(_enemy_2, CastAnimation)
	assert_eq(created_cast_nodes_enemy_2.size(), 1)
