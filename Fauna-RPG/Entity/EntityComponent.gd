extends Node2D
class_name EntityComponent
## Base component that an entity can use.
## 
## Call init_entity_component on the Entity when initialized. This way the component can have a
## reference to the owner for whatever it needs.


var entity_owner: Entity = null


func init_entity_component(in_owner: Entity) -> void:
	entity_owner = in_owner
