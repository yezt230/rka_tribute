extends CharacterBody2D

@onready var player_rubbing = $"../../PlayerRubbing"
@onready var woods_bg = $WoodsBg
@onready var cave_darken_tween_timer : Timer = $"../CaveDarkenTweenTimer"


func _ready():
	#darken_cave()
	player_rubbing.jumped_on_cart.connect(Callable(self, "_player_jumped_on_cart"))


func _physics_process(_delta):
	move_and_slide()	


func _player_jumped_on_cart():	
	cave_darken_tween_timer.start()


func _on_cave_darken_tween_timer_timeout():
	darken_cave()
	
	
func darken_cave():
	print("jump from signal")
	var shader_material := woods_bg.material as ShaderMaterial

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
