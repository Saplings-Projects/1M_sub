extends Resource
class_name EnergyData
## Defines how much energy is needed to perform an action
##
## This is mainly used for cards for now, but it could be used for other things. [br]
## It also only contains an energy cost for now. Having its own class helps with typing and organization, instead of just using an int.


## The energy cost of the action [br]
@export var energy_cost: int = 0
