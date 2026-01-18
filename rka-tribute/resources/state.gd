class_name State extends Node

@export var animation_name: String
# Hold a reference to the parent so that it can be controlled by the state
var parent: Player

func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> State:
	return null


func process_input(_event: InputEvent) -> State:
	return null
