extends Node
## Globally accessible for easy access to the enemies
## They are for now only accessible through the battler which is not very practical

## The list of enemies to spawn
@export var enemy_list: Array[Entity]:
    set(list):
        enemy_list = list
