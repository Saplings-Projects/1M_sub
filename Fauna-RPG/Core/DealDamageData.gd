extends Resource
class_name DealDamageData
## Data that is passed to HealthComponent deal_damage.


var damage: float
var attacker: Entity
var ignore_attacker_buffs: bool = false
var ignore_victim_buffs: bool = false
