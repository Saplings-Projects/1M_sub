extends CardBase
class_name Card_DamageHealth
# Deals damage equal to the amount of health that the caster has lost.


func _deal_damage(caster: Entity, target: Entity) -> void:
	var health_lost: float = caster.get_health_component().max_health - caster.get_health_component().current_health
	
	var damage_data: DealDamageData = DealDamageData.new()
	damage_data.damage = health_lost
	damage_data.caster = caster
	damage_data.ignore_caster_buffs = true
	damage_data.ignore_target_buffs = true
	
	target.get_health_component().deal_damage(damage_data)
