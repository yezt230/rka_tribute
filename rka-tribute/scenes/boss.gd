extends CharacterBody2D

@onready var coupling_rod_orbit = $CouplingRodOrbit
@onready var coupling_rod_sprite = $CouplingRodOrbit/CouplingRodSprite
@onready var state_machine = $StateMachine
@onready var state_label = $StateLabel
@onready var speed_label = $SpeedLabel
@onready var health_component = $HealthComponent

func _ready():
	state_machine.init(self)
	health_component.zero_health.connect(_on_zero_health)

func _physics_process(delta: float) -> void:
	var current_state = state_machine.current_state
	if current_state:
		state_label.text = current_state.name
	#speed_label.text = str("%0.1f" % global_position.x)
	speed_label.text = str(health_component.health)
	# Add the gravity. 
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta
		
	else:
		velocity.y = 0
		
	coupling_rod_orbit.rotation += 8.0 * delta
	coupling_rod_sprite.rotation = -coupling_rod_orbit.rotation
		
	move_and_slide()


func _on_zero_health():
	queue_free()
