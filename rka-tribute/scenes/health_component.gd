extends Node2D

signal zero_health

@onready var boss = $".."

var starting_health = 100
var health = starting_health

func _on_boss_hurtbox_body_entered(body):
	#DEBUG: health
	#health -= 5
	
	if health <= 0:
		health = 0
		emit_signal("zero_health")
	
	
