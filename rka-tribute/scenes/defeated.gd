extends State

@onready var phase_transition_timer = $"../../PhaseTransitionTimer"
@onready var defeat_explosion_particle = $"../../DefeatExplosionParticle"
@onready var explosion_stream_player = $"../../ExplosionStreamPlayer"
@onready var cover_animation_player = $"../../CoverAnimationPlayer"
@onready var cover_tear_off_animation_player = $"../../CoverTearOffAnimationPlayer"
@onready var boss_orb_attack_manager = $"../../BossOrbAttackManager"
@onready var hit_flash_component = $"../../HitFlashComponent"

var defeat_flash_tween: Tween

func enter():
	#TODO: replacement web explosion FX
	if OS.has_feature("web"):
		start_defeat_flash()
	else:
		defeat_explosion_particle.emitting = true
		#TODO: remove from prod release
		start_defeat_flash()
		
	if boss_orb_attack_manager:
		boss_orb_attack_manager.attack_timer.stop()
	parent.phase += 1
	phase_transition_timer.start()
	play_explosion_sound_loop()
	if parent.phase == 2:
		parent.truck_body_sprite.frame = 2

	#removing claw hitboxes when boss is defeated in Phase 2
	if parent.phase == 4:
		roof_tearing_off_animation()
		var claws = get_tree().get_nodes_in_group("claws")
		parent.truck_body_sprite.frame = 2
		for claw in claws:
			var claw_hitbox = claw.get_node("PlayerColliderBox") as Area2D
			claw_hitbox.queue_free() 


func play_explosion_sound_loop():
	explosion_stream_player.play_random_pitch()


func _on_explosion_stream_player_finished():
	print("play exp")
	play_explosion_sound_loop()
	
	
func exit() -> void:
	stop_defeat_flash()
	explosion_stream_player.stop()
	defeat_explosion_particle.restart() 
	defeat_explosion_particle.emitting = false
	
	
func start_defeat_flash() -> void:
	var material: ShaderMaterial = hit_flash_component.hit_flash_material

	if material == null:
		return

	if defeat_flash_tween != null and defeat_flash_tween.is_valid():
		defeat_flash_tween.kill()

	defeat_flash_tween = create_tween()
	defeat_flash_tween.set_loops()

	# Fade into the flash.
	defeat_flash_tween.tween_property(
		material,
		"shader_parameter/lerp_percent",
		1.0,
		0.08
	)

	# Fade back to normal.
	defeat_flash_tween.tween_property(
		material,
		"shader_parameter/lerp_percent",
		0.0,
		0.08
	)

	# Remain normal for half a second before flashing again.
	defeat_flash_tween.tween_interval(0.25)
	

func stop_defeat_flash() -> void:
	if defeat_flash_tween != null and defeat_flash_tween.is_valid():
		defeat_flash_tween.kill()

	defeat_flash_tween = null

	var material: ShaderMaterial = hit_flash_component.hit_flash_material

	if material != null:
		material.set_shader_parameter("lerp_percent", 0.0)


func roof_tearing_off_animation():
	cover_animation_player.play("tear_off")
	cover_tear_off_animation_player.play("tear_off")	
	
