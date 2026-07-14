extends Node2D

@onready var iris_in = $IrisIn

func _ready():
	#func play_iris_in() -> void:
	var material2 := iris_in.material as ShaderMaterial
	material2.set_shader_parameter("progress", 0.0)

	var tween := create_tween()
	tween.tween_method(
		func(value: float):
			material2.set_shader_parameter("progress", value),
		0.0,
		1.0,
		0.8
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
