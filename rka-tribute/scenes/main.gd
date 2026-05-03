extends Node2D

@onready var health_component = $Boss/HealthComponent

var phases : Array = [0,1,2]
var phase : int = phases[0]

func _ready():
	health_component.zero_health.connect(_on_boss_zero_health)
	
func _on_boss_zero_health():
	pass
