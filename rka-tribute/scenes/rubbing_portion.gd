extends Node2D     

@onready var player = $PlayerRubbing
@onready var bear_relaxing = $BearRelaxing

var scene_movable = false

func _ready():
	pass


func _on_stall_timer_timeout():
	scene_movable = true                
	print("ready to move")
 
