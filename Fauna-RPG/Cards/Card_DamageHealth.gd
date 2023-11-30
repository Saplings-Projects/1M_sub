extends CardBase
class_name Card_DamageHealth
# Deals damage equal to the amount of health that the attacker has lost.


func _deal_damage(attacker : Entity, victim : Entity):
	var health_lost = attacker.get_health_component().max_health - attacker.get_health_component().current_health
	
	var damage_data : DealDamageData = DealDamageData.new()
	damage_data.damage = health_lost
	damage_data.attacker = attacker
	damage_data.ignore_attacker_buffs = true
	damage_data.ignore_victim_buffs = true
	
	victim.get_health_component().deal_damage(damage_data)
