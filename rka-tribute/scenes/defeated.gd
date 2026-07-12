extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"
@onready var defeat_explosion_particle = $"../../DefeatExplosionParticle"
@onready var explosion_stream_player = $"../../ExplosionStreamPlayer"
@onready var cover_animation_player = $"../../CoverAnimationPlayer"
@onready var cover_tear_off_animation_player = $"../../CoverTearOffAnimationPlayer"

func enter():
	defeat_explosion_particle.emitting = true
	parent.phase += 1
	phase_transition_timer.start()
	play_explosion_sound_loop()
#	cover tearing off animation
	if parent.phase == 2:
		cover_animation_player.play("tear_off")
		cover_tear_off_animation_player.play("tear_off")	
	#removing claw hitboxes when boss is defeated in Phase 2
	if parent.phase == 4:
		var claws = get_tree().get_nodes_in_group("claws")
		for claw in claws:
			var claw_hitbox = claw.get_node("PlayerColliderBox") as Area2D
			claw_hitbox.queue_free() 


func play_explosion_sound_loop():
	explosion_stream_player.play_random_pitch()


func _on_explosion_stream_player_finished():
	print("play exp")
	play_explosion_sound_loop()
	
	
func exit() -> void:
	explosion_stream_player.stop()
	defeat_explosion_particle.restart() 
	defeat_explosion_particle.emitting = false
	
