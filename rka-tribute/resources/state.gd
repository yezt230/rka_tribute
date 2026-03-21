class_name State extends Node

@export var animation_name: String
# Hold a reference to the parent so that it can be controlled by the state
#maybe it's more optimal to declare this as a type ("var parent: Player" etc)
#but since PlayerRubbing depends on it too, it can't be srictly defined as one type
var parent

func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> State:
	return null


func process_input(_event: InputEvent) -> State:
	return null
