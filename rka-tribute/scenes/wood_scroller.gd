extends CharacterBody2D

@onready var player_rubbing = $"../../PlayerRubbing"
@onready var woods_bg = $WoodsBg


func _ready():
	#_player_jumped_on_cart()
	pass

func _physics_process(_delta):
	move_and_slide()
	player_rubbing.jumped_on_cart.connect(Callable(self, "_player_jumped_on_cart"))


func _player_jumped_on_cart():
	print("jump from signal")
	var shader_material := woods_bg.material as ShaderMaterial

	if shader_material == null:
		return

	var duration := 2.0
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		shader_material,
		"shader_parameter/hue_shift",
		0.5,
		duration
	)

	tween.tween_property(
		shader_material,
		"shader_parameter/saturation",
		1.02,
		duration
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
