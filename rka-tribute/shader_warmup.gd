extends Node2D

@onready var cave_transition_shader_sprite = $CaveTransitionShaderSprite
@onready var gpu_particles_2d : GPUParticles2D = $ExplosionEmitter/GPUParticles2D
@onready var gpu_particles_2d_2 : GPUParticles2D = $CannonParticles/GPUParticles2D

func _ready():
	gpu_particles_2d.preprocess = 1.0
	gpu_particles_2d_2.preprocess = 1.0
#	cave shader
	var shader_material := cave_transition_shader_sprite.material as ShaderMaterial

	if shader_material == null:
		return

	var duration := 2.0 - 1.2
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		shader_material,
		"shader_parameter/hue_shift",
		0.5,
		0.1
	)

	tween.tween_property(
		shader_material,
		"shader_parameter/saturation",
		1.02,
		0.1
	)

	tween.tween_property(
		shader_material,
		"shader_parameter/brightness",
		-0.45,
		duration
	)

	tween.tween_property(
		shader_material,
		"shader_parameter/contrast",
		0.76,
		duration
	)



func _on_change_to_start_screen_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
