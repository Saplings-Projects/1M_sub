extends Node
class_name EntityComponent
## Base component that an entity can use.
## 
## Call init_entity_component on the Entity when initialized. This way the component can have a
## reference to the owner for whatever it needs.


## The entity that owns this component.
var entity_owner: Entity = null # TODO change this name entity_owner to make it clearer

## Set the [param entity_owner] to be [param in_owner].
func init_entity_component(in_owner: Entity) -> void:
	entity_owner = in_owner
