extends Node2D

signal zero_health

@onready var boss = $".."

var starting_health =  50 if OS.is_debug_build() else 50
var phase_2_health =  50 if OS.is_debug_build() else 50
var health = starting_health
var damage_amount = 10

func struck_by_player_attack():
	#DEBUG: health
	health -= damage_amount
	
	if health <= 0:
		health = 0
		emit_signal("zero_health")
	
	
