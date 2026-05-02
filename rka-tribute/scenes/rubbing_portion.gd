extends Node2D     

@onready var player = $PlayerRubbing
@onready var bear_relaxing = $BearRelaxing
@onready var boss: CharacterBody2D = $Boss

var scene_movable = false

func _ready():
	boss.modulate.a = 0


func _on_stall_timer_timeout():
	scene_movable = true
 
