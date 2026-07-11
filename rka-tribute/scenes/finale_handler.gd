extends Node2D

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var player = $"../Player"
@onready var player_cannot_move_timer = $PlayerCannotMoveTimer
@onready var tween_to_center_timer = $TweenToCenterTimer

@onready var health_component = boss.get_node("HealthComponent")

func _ready():
	color_rect.modulate.a = 0
	health_component.zero_health.connect(_on_boss_defeated)
	
	
func _on_boss_defeated():
	#DEBUG: needs to be gated by phase 4
	if boss.phase == 4:	
		#@todo most of this needs to be after a delay
		player_cannot_move_timer.start()


func _on_player_cannot_move_timer_timeout():
	player.player_can_move = false
	tween_to_center_timer.start()	


func _on_tween_to_center_timer_timeout():
	var target_x = 700.0
	var duration = 2.8
	var tween = create_tween()
	var center_screen_dimensions = [get_viewport_rect().size[0]/2, get_viewport_rect().size[1]/2]	
		
	tween.tween_property(player, "global_position", Vector2(center_screen_dimensions[0], center_screen_dimensions[1]), duration) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)		
	#DEBUG: color fadeout
	var tween2 = create_tween()
	tween2.tween_property(color_rect, "modulate:a", 1.0, duration)

	await tween2.finished

	get_tree().change_scene_to_file("res://scenes/victory_portion.tscn")
