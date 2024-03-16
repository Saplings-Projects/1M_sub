extends Resource
class_name CardBase
## Resource that holds data about a card and provides functions that all derived cards could
## use if they want.
##
## The intention with this is to provide functionality that is common to a lot of cards,
## like dealing damage, drawing cards, and restoring resources.
## If you want functionality that's unique to a certain card, then create a new child of this
## and override one of the functions below.
## This resource also has data that is used for displaying the card in the world, like
## description, title, and key art.
## This includes functionality for applying damage to both the target and caster. Casters may
## wish to take damage in some contexts.
## For example, consider the card: "Deal 10 damage to all enemies, but take 3 damage"

@export var application_type: Enums.ApplicationType = Enums.ApplicationType.ENEMY_ONLY
@export var card_title: String = "NULL"
@export var card_key_art: ImageTexture = null
@export var card_description: String = "NULL"

@export var card_effects_data: Array[EffectData] = []

@export var energy_info: EnergyData = EnergyData.new()

var _card_effects_queue: Array[EffectData] = []


func _ready() -> void:
	card_effects_data = []

# Need a parser of some sort to read a plainform card data and translate it to EffectData
# This will call EffectData.add_effect_data() in a loop for every new effect

@warning_ignore("unused_parameter")
func parse_card_data(card_data: Dictionary) -> void:
	# TODO
	pass


func can_play_card(caster: Entity, target: Entity) -> bool:
	return caster.get_party_component().can_play_on_entity(application_type, target)


func on_card_play(caster: Entity, base_target: Entity) -> void:
	if caster is Player:
		PlayerManager.player.get_energy_component().use_energy(self)	
	
	if _card_effects_queue.size() > 0:
		push_error("Tried to play more card animations while some are already playing!")
		return
	
	_card_effects_queue = card_effects_data.duplicate()
	_handle_effects_queue(caster, base_target)


func _handle_effects_queue(caster: Entity, base_target: Entity) -> void:
	var card_effect: EffectData = _card_effects_queue[0]
	var animation_data: CastAnimationData = card_effect.animation_data
	var list_targets: Array[Entity] = card_effect.targeting_function.generate_target_list(base_target)
	var created_cast_animations: Array[CastAnimation] = []
	
	var can_use_animation: bool = animation_data != null and animation_data.can_use_animation()
	
	if can_use_animation:
		created_cast_animations = animation_data.cast_position.initialize_animation(animation_data.cast_animation_scene, caster, list_targets)
		
		# Wait for animation to trigger hits
		for cast_animation in created_cast_animations:
			cast_animation.on_animation_hit_triggered.connect(animation_hit.bind(card_effect, caster))
			cast_animation.play_animation()
	else:
		push_warning("No animation set in effect data for card " + resource_path + ". Skipping animation.")
		
		# Apply effects to all targets instantly if there is no animation
		for current_target in list_targets:
			card_effect.apply_effect_data(caster, current_target)
	
	# Wait for last animation to complete
	if not created_cast_animations.is_empty():
		await created_cast_animations[created_cast_animations.size() - 1].on_animation_cast_complete
	
	_card_effects_queue.remove_at(0)
	
	# Handle next effect in the queue or finish casting
	if _card_effects_queue.size() > 0:
		_handle_effects_queue(caster, base_target)
	else:
		CardManager.on_card_action_finished.emit(self)


func animation_hit(hit_target: Entity, card_effect: EffectData, caster: Entity) -> void:
	card_effect.apply_effect_data(caster, hit_target)
