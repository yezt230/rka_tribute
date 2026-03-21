class_name PlayerRubbing extends CharacterBody2D

#collision for ground is on layer 3, orb attack is 4

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const GRAV_ADJUSTMENT: float = 2.0

@onready var player_dir: float = 1.0
@onready var player_sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var debug_label = $DebugLabel
@onready var debug_label_2 = $DebugLabel2
@onready var debug_label_3 = $DebugLabel3
@onready var state_machine = $StateMachineRubbing
@onready var idle = $StateMachineRubbing/IdleRubbing
@onready var knockback_stall_timer = $KnockbackStallTimer
	#probably change canAttackYet from a boolean to an array or three-way condition
	#so the player can't attack in the ending sequence
@onready var canAttackYet : bool = false 

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
	#take_dam
	pass
