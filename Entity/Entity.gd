extends Node2D
class_name Entity
## Base object that enemies and players are derived from. 
##
## Entities are made up of components to reduce clutter in this class. 


func _ready() -> void:
	get_status_component().init_entity_component(self)
	get_health_component().init_entity_component(self)
	get_party_component().init_entity_component(self)
	get_stat_component().init_entity_component(self)
	
	get_health_component().team = get_party_component().team


func get_status_component() -> StatusComponent:
	return Helpers.get_first_child_node_of_type(self, StatusComponent) as StatusComponent

	
func get_stat_component() -> StatComponent:
	return Helpers.get_first_child_node_of_type(self, StatComponent) as StatComponent

	
func get_health_component() -> HealthComponent:
	return Helpers.get_first_child_node_of_type(self, HealthComponent) as HealthComponent


func get_party_component() -> PartyComponent:
	return Helpers.get_first_child_node_of_type(self, PartyComponent) as PartyComponent


func get_click_handler() -> ClickHandler:
	return Helpers.get_first_child_node_of_type(self, ClickHandler) as ClickHandler

