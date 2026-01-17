extends Node

@onready var boss = $".."
@onready var train_body_sprite = %TrainBodySprite
@onready var wheel_sprite = $"../WheelSprite"
@onready var wheel_sprite_2 = $"../WheelSprite2"
@onready var wheel_sprite_3 = $"../WheelSprite3"

var sprite_arr = []

var hit_flash_material = preload("res://scenes/hit_flash_component.tres")
var hit_flash_tween: Tween

func _ready():
	#train_body_sprite.material = hit_flash_material
	sprite_arr = [train_body_sprite, wheel_sprite, wheel_sprite_2, wheel_sprite_3]
	for sprite in sprite_arr:
		sprite.material = hit_flash_material

func _on_boss_hurtbox_body_entered(body):
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(train_body_sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(train_body_sprite.material, "shader_parameter/lerp_percent", 0.0, 0.2)
