extends Node2D

@onready var train_borders_activator_collider = $TrainBordersActivatorCollider
@onready var train_borders = $TrainBorders
@onready var left_arena_boundary = $TrainBorders/CollisionShape2D2

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var health_component = boss.get_node("HealthComponent")

func _ready():
	_disable_boundaries()
	train_borders_activator_collider.body_entered.connect(_on_trigger_body_entered)
	health_component.zero_health.connect(_on_boss_zero_health)


func _on_trigger_body_entered(body):
	if body.is_in_group("boss"):
		_enable_boundaries()
		
		
func _enable_boundaries():
	left_arena_boundary.global_position.y = 486
	
	
func _disable_boundaries():
	left_arena_boundary.global_position.y = -400
	
	
func _on_boss_zero_health():
	_disable_boundaries()
