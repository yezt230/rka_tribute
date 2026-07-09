class_name PlayerRubbing extends CharacterBody2D

#collision for ground is on layer 3, orb attack is 4
signal rubbing_started
signal rubbing_stopped
signal land_on_belly

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var state_machine = $StateMachineRubbing
@onready var rub_hitbox = $Area2D/RubHitbox
@onready var debug_label_4 = $DebugLabel2
@onready var drop_down_timer = $DropDownTimer
@onready var cart = $"../Cart"
@onready var bear_shake_animation_player : AnimationPlayer = $"../BearRelaxing/ShakeAnimationPlayer"
@onready var boing_stream_player = $"../BoingStreamPlayer"
@onready var jump_stream_player = $JumpStreamPLayer
@onready var bear_belly_platform = $"../BearRelaxing/BearBellyPlatform"
@onready var bear_belly_collision_shape_2d = $"../BearRelaxing/BearBellyPlatform/CollisionPolygon2D"
@onready var bear_belly_platform_y = bear_belly_platform.global_position.y
@onready var environment_controller = $"../EnvironmentController"
#should be a global variable? player will be locked
#out of moving several times

var is_on_belly_platform := false
var belly_platform_currently_rising = false
var direction_to_play_rubbing_anim : float = 1.0
var player_landed_on_belly_yet = false
var player_dir: float = 1.0
var current_state_name : String
var jump_onto_cart_flag : bool = false
var has_jumped_onto_cart : bool = false
var player_can_move : bool = true

func _ready():
	cart.trigger_cart_cutscene.connect(self._on_trigger_cart_cutscene)
	state_machine.init(self)
	

func _process(_delta):
	if state_machine:
		current_state_name = state_machine.get_current_state()
		debug_label.text = str(is_on_belly_platform)
	
	if not is_on_belly_platform:
		player_landed_on_belly_yet = false
	
	if has_jumped_onto_cart:
		player_sprite.global_position.x = cart.global_position.x
	
		

func _physics_process(delta: float) -> void:
	# Gravity always applies
	if not is_on_floor():
		velocity += get_gravity() * GRAV_ADJUSTMENT * delta

	# Handle jump
	if player_can_move:
		if Input.is_action_just_pressed("UP") and is_on_floor():		
			jump_stream_player.play()	
			velocity.y = JUMP_VELOCITY
			is_on_belly_platform = false

		if Input.is_action_just_pressed("DOWN") and is_on_floor():
			if bear_belly_collision_shape_2d:
				bear_belly_collision_shape_2d.disabled = true
			drop_down_timer.start()

	# Horizontal movement
	
	var direction := Input.get_axis("LEFT", "RIGHT") if player_can_move else 0.0
	debug_label_4.text = str(direction)
	if direction != 0.0:
		direction_to_play_rubbing_anim = direction
	
	if player_can_move:
		get_orientation(direction)	

	rub_hitbox.position.x = 35 * player_dir

	if player_can_move:
		if direction and (current_state_name != "RubStanding" and \
		current_state_name != "RubCrouching" and current_state_name != "IdleRubbing"):
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if not jump_onto_cart_flag:
			velocity.x = 0

	move_and_slide()
	
	if direction <= 0:
		environment_controller.set_direction(0)
	
	var jump_state : State
	if state_machine:
		jump_state = state_machine.get_node("JumpRubbing")

	if not is_on_floor():
		state_machine.change_state(jump_state)
		
	var pushing_bg := false

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is StaticBody2D and collider.name == "BG":
			pushing_bg = direction > 0

		if collision.get_normal().y < 0 and collider and collider.name == "BearBellyPlatform":
			is_on_belly_platform = true
			depress_belly_platform()
		else:
			is_on_belly_platform = false

	environment_controller.set_direction(1 if pushing_bg else 0)

func get_orientation(dir):
	# direction can only be -1 or 1
	if dir != 0.0:
		player_dir = dir
		player_sprite.scale.x = dir
		
		
func resolve_locomotion_state() -> State:
	# Airborne beats everything
	if not is_on_floor():
		return state_machine.get_node("JumpRubbing")

	# Horizontal input
	if player_can_move:
		if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
			return state_machine.get_node("RunRubbing")

	return state_machine.get_node("IdleRubbing")


func jump_onto_cart():
	var static_state = state_machine.get_node("Static")
	state_machine.change_state(static_state)


func horz_tween_onto_cart():
	##horizontal movement for jumping onto cart
	var target_x = cart.global_position.x

	var tween = create_tween()
	tween.tween_property(player_sprite, "global_position:x", target_x, 1.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_horz_tween_finished)
	
	
func _on_horz_tween_finished():	
	has_jumped_onto_cart = true
	#shrink the player down after jumping on the cart
	var tween = create_tween()
	var sprite_scale = 0.8
	
	var duration = 2.0
	
	tween.tween_property(player_sprite, "scale", Vector2(sprite_scale,sprite_scale), duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	
#	slightly move squirrel sprite down to compensate for overall shrunk sprite
	tween.parallel().tween_property(player_sprite, "global_position:y", 475, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	
func cart_wheel_start_rotating():
	$"../TransitionToMainTimer".start()
	environment_controller.start_cart_cutscene()
	
	
func depress_belly_platform():	
	if player_landed_on_belly_yet:
		return
	if belly_platform_currently_rising:
		return
	if velocity.y < 0:
		return

	emit_signal("land_on_belly")
	boing_stream_player.play()
	print("bellied")
	player_landed_on_belly_yet = true
	belly_platform_currently_rising = true
	
	var start_y = bear_belly_platform.global_position.y
	var dipped_y = start_y + 25.0

	var tween = create_tween()

	tween.tween_property(
		bear_belly_platform,
		"global_position:y",
		dipped_y,
		0.1
	).set_trans(Tween.TRANS_SINE)

	tween.tween_property(
		bear_belly_platform,
		"global_position:y",
		bear_belly_platform_y,
		0.2
	).set_trans(Tween.TRANS_SINE)

	tween.finished.connect(_on_finish_belly_platform_rising)
	
	
func _on_drop_down_timer_timeout():
	if bear_belly_collision_shape_2d:
		bear_belly_collision_shape_2d.disabled = false


func _on_trigger_cart_cutscene():
	jump_onto_cart()


func _on_transition_to_main_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_finish_belly_platform_rising():
	belly_platform_currently_rising = false
