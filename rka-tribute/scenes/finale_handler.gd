extends Node2D

@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var player = $"../Player"

@onready var health_component = boss.get_node("HealthComponent")

func _ready():
	color_rect.modulate.a = 0
	health_component.zero_health.connect(_on_boss_defeated)
	
	
func _on_boss_defeated():
	#DEBUG: needs to be gated by phase 4
	if boss.phase == 4:	
		#@todo most of this needs to be after a delay
		player.player_can_move = false
		
		var target_x = 700.0
		var duration = 2.8
		var tween = create_tween()

		tween.tween_property(player, "global_position:x", target_x, duration) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_OUT)
		#DEBUG: color fadeout
		var tween2 = create_tween()
		tween2.tween_property(color_rect, "modulate:a", 1.0, 0.8)
		
		#color_rect.modulate.a = 100
		#animation_player.play("fade_to_black")
