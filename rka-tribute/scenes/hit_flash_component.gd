extends Node

@onready var boss = $".."
@onready var sprite_2d = $"../Sprite2D"

var hit_flash_material = preload("res://scenes/hit_flash_component.tres")
var hit_flash_tween: Tween

func _ready():
	sprite_2d.material = hit_flash_material
	

func _on_boss_hurtbox_body_entered(body):
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite_2d.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite_2d.material, "shader_parameter/lerp_percent", 0.0, 0.2)
