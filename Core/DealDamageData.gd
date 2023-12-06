extends Resource
class_name DealDamageData
## Data that is passed to HealthComponent deal_damage.


var damage: float
var caster: Entity
var ignore_caster_buffs: bool = false
var ignore_target_buffs: bool = false
