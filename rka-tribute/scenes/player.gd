class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_dir: float = 1.0
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var debug_label_2 = $DebugLabel2
@onready var debug_label_3 = $DebugLabel3
@onready var state_machine = $StateMachine
@onready var idle = $StateMachine/Idle
@onready var knockback_stall_timer = $KnockbackStallTimer

func _ready():
	print("print this once")
	state_machine.init(self)
	

func _process(_delta):
	var current_state_name = state_machine.get_current_state()
	debug_label.text = current_state_name
	

func _physics_process(delta: float) -> void:
	# Gravity always applies
	if not is_on_floor():
		velocity += get_gravity() * GRAV_ADJUSTMENT * delta

	# 🚫 Disable player input during Hurt
	if state_machine.current_state.name == "Hurt":
		move_and_slide()
		return

	# Handle jump
	if Input.is_action_just_pressed("UP") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Horizontal movement
	var direction := Input.get_axis("LEFT", "RIGHT")
	get_orientation(direction)

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func get_orientation(dir):
	# direction can only be -1 or 1
	if dir != 0.0:
		player_dir = dir
		player_sprite.scale.x = dir
		
		
func resolve_locomotion_state() -> State:
	# Airborne beats everything
	if not is_on_floor():
		return state_machine.get_node("Jump")

	# Horizontal input
	if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
		return state_machine.get_node("Run")

	return state_machine.get_node("Idle")


func _on_area_2d_area_entered(area):
	take_damage()


func take_damage() -> void:
	# Prevent re-entry if already hurt
	if state_machine.get_current_state() == "Hurt":
		return

	var hurt_state: State = state_machine.get_node("Hurt")
	state_machine.change_state(hurt_state)


func apply_knockback(force: float) -> void:
	knockback_stall_timer.start()
	# Push opposite facing direction
	velocity.x = -player_dir * force


func _on_knockback_stall_timer_timeout():
	velocity.x = 0
