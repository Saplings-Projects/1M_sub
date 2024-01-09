extends Resource
class_name DealDamageData
## Data that is passed to HealthComponent deal_damage.


var damage: float
var caster: Entity
var ignore_caster_status: bool = false
var ignore_target_status: bool = false

# TODO is this needed anymore ?
