class_name EnemyGroup extends Node

## The enemies that are in this group
@export var enemy_list: Array[Enemy]

## The position of those enemies on the screen [br]
## @experimental
## This could be changed to be automatically calculated maybe
@export var positions: Array[Vector2]
