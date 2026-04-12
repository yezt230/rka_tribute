class_name PlayerRubbing extends CharacterBody2D

#collision for ground is on layer 3, orb attack is 4
signal rubbing_started
signal rubbing_stopped

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_dir: float = 1.0
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var state_machine = $StateMachineRubbing
@onready var idle = $StateMachineRubbing/IdleRubbing
@onready var current_state_name : String
@onready var rub_hitbox = $Area2D/RubHitbox
@onready var debug_label_4 = $DebugLabel2
@onready var collision_shape_2d = $CollisionShape2D
@onready var rubbing_shake_inc_timer = $RubbingShakeIncTimer
@onready var drop_down_timer = $DropDownTimer
@onready var bear_shake_animation_player : AnimationPlayer = $"../BearRelaxing/ShakeAnimationPlayer"
@onready var bear_shake_tracker : int = 0
@onready var bear_relaxing = $"../BearRelaxing"
@onready var bear_belly_collision_shape_2d = $"../BearBellyPlatform/CollisionShape2D"
@onready var bear_remove_timer = $"../BearRemoveTimer"
@onready var boss = $"../Boss"
@onready var boss_animation_player = $"../Boss/AnimationPlayer"
@onready var wood_scroller = $"../BG/WoodScroller"
@onready var cart = $"../Cart"
@onready var jump_onto_cart_flag : bool = false
#should be a global variable? player will be locked
#out of moving several times
@onready var player_can_move : bool = true
@onready var transition_to_main_timer = $"../TransitionToMainTimer"

var is_on_belly_platform := false
var current_floor_collider: Object = null
var is_overlapping_bear := false
var is_rubbing := false
var has_rubbing_timer_started = false

func _ready():
	state_machine.init(self)
	print(cart.animation_player)
	rubbing_shake_inc_timer.timeout.connect(_on_rubbing_shake_inc_timer_timeout)
	

func _process(_delta):
	#print("player can move: " + str(player_can_move))
	if state_machine:
		current_state_name = state_machine.get_current_state()
		debug_label.text = current_state_name
		debug_label_4.text = str(rubbing_shake_inc_timer.time_left)
		evaluate_rub_state()
	
	if cart.global_position.x < 1300 and not jump_onto_cart_flag:
		jump_onto_cart()

func _physics_process(delta: float) -> void:
	# Gravity always applies
	if not is_on_floor():
		velocity += get_gravity() * GRAV_ADJUSTMENT * delta

	# Handle jump
	if player_can_move:
		if Input.is_action_just_pressed("UP") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if Input.is_action_just_pressed("DOWN") and is_on_floor():
			if bear_belly_collision_shape_2d:
				bear_belly_collision_shape_2d.disabled = true
			drop_down_timer.start()

	# Horizontal movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	if player_can_move:
		get_orientation(direction)	

	rub_hitbox.position.x = 35 * player_dir

	if player_can_move:
		if direction and (current_state_name != "RubStanding" and current_state_name != "IdleRubbing"):
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if not jump_onto_cart_flag:
			velocity.x = 0

	move_and_slide()
	
	#DEBUG: just getting collision names
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is StaticBody2D:
			#print("Hit a static body:", collider.name)
			if collider.name == "BG":
				move_environment(direction)
	#end
	
	var jump_state : State
	if state_machine:
		jump_state = state_machine.get_node("JumpRubbing")

	if not is_on_floor():
		state_machine.change_state(jump_state)
		
	# check if on the platform specfically
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_normal().y < 0:
			var collider = collision.get_collider()
			current_floor_collider = collider

			if collider and collider.name == "BearBellyPlatform":
				is_on_belly_platform = true
			else:
				is_on_belly_platform = false

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
	
	
func _on_area_2d_body_entered(body):
	if body.name == "BearRelaxing":
		is_overlapping_bear = true
		evaluate_rub_state()


func _on_area_2d_body_exited(body):
	if body.name == "BearRelaxing":
		is_overlapping_bear = false
		stop_rubbing()


func evaluate_rub_state():
	if (is_overlapping_bear or is_on_belly_platform) and is_rubbing:
		start_rubbing()
	else:
		stop_rubbing()
		

func start_rubbing():
	if not has_rubbing_timer_started:
		rubbing_shake_inc_timer.start()
		has_rubbing_timer_started = true
	rubbing_shake_inc_timer.paused = false
	emit_signal("rubbing_started")


func stop_rubbing():
	rubbing_shake_inc_timer.paused = true
	emit_signal("rubbing_stopped")


func move_environment(direction):
	if player_can_move:
		wood_scroller.velocity.x = -(direction * SPEED)
		cart.velocity.x = -(direction * SPEED)
	else:
		wood_scroller.velocity.x = 0
		cart.velocity.x = 0


func jump_onto_cart():
	var static_state = state_machine.get_node("Static")
	state_machine.change_state(static_state)


func cart_wheel_start_rotating():
	transition_to_main_timer.start()
	cart.animation_player.play("rotate")
	var shared_velocity_x = -120
	cart.velocity.x = shared_velocity_x
	velocity.x = shared_velocity_x
	cart.move_and_slide()
	
	
func remove_bear():
	bear_remove_timer.start()
	
	
func _on_drop_down_timer_timeout():
	if bear_belly_collision_shape_2d:
		bear_belly_collision_shape_2d.disabled = false


func _on_rubbing_shake_inc_timer_timeout():
	if bear_shake_animation_player:
		match bear_shake_tracker:
			0:
				bear_shake_animation_player.play("rub_4")
				bear_shake_tracker = 1
			1:
				bear_shake_animation_player.play("rub_3")
				boss_animation_player.play("travel_right")
				remove_bear()
				bear_shake_tracker = 2
			2:
				bear_shake_animation_player.play("rub_2")
				bear_shake_tracker = 3
			3:
				boss_animation_player.play("travel_right")


func _on_transition_to_main_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_bear_remove_timer_timeout():
	if bear_relaxing:
		bear_relaxing.queue_free()
