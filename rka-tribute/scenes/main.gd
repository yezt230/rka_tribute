extends Node2D

@onready var health_component = $Boss/HealthComponent
@onready var boss = $Boss

func _ready():
	#DEBUG: boss_timings: Boss initial position
	#boss.global_position.x = -1100
	boss.global_position.x = -300 if OS.is_debug_build() else -1100
	#pass
