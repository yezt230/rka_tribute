extends Node2D

@onready var iris_in = $CanvasLayer2/IrisIn


#func _ready():
	#iris_in_animation()


func _on_iris_in_timer_timeout():
	iris_in_animation()
	
	
func iris_in_animation():
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
