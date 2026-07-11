extends CharacterBody2D

@onready var dir = 1
@onready var state_machine = $StateMachine
@onready var defeated_state = $StateMachine/Defeated
@onready var state_label = $StateLabel
@onready var speed_label = $SpeedLabel
@onready var health_component = $HealthComponent
@onready var hit_flash_component = $HitFlashComponent
#DEBUG: Prod value is 0
@onready var phase = 2
#PHASES
#1: incoming on ground track
#2: defeated on ground track
#3: incoming on elevated track
#4: defeated on elevated track

#phases here doesn't mean the same thing as the
#Boss Phase States. it tracks a diferent set of
#states for the boss that only roughly correlates

	#DEBUG: boss_timings:
	#^ the comment to search for to find code related
#	to boss's real cycles instead of shortened debugging
#	version
	#DEBUG: boss_timings:
#	Phasetransitiontimer handles pause before boss enters screen
#DEBUG: speed
#const SPEED : float = 17500
const SPEED : float = 7500
#const SPEED : float = 0
var boss_speed : float = SPEED
var current_speed : float
var final_defated = false

func _ready():
	state_machine.init(self)
	health_component.zero_health.connect(_on_zero_health)

func _physics_process(delta: float) -> void:	
	var current_state = state_machine.current_state
	if current_state:
		state_label.text = current_state.name
	
	#todo move to state?
	#boss direction whether or not he's been defeated
	if current_state.name == "Defeated":
		if phase == 4:
			print('second defeat')
			dir = 0
			if !final_defated:
				final_defated = true
				#also play back-tearing-off and bear escaping animation
				final_defeat_tween()
		else:
			print('first defeat')
			dir = -1
	elif current_state.name == "Incoming":
		dir = 1
		
	# boss moves faster in second phase
	if phase == 3:
		current_speed = boss_speed * dir * delta * 1.5
	else:
		current_speed = boss_speed * dir * delta
		
	velocity.x = current_speed	
	#speed_label.text = str("%0.1f" % global_position.x)
	#speed_label.text = str(health_component.health)
	speed_label.text = str(phase)
	# Add the gravity. 
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta		
	else:
		velocity.y = 0		
	move_and_slide()
 

func _on_zero_health():
	state_machine.change_state(defeated_state)


func _on_wall_bounce_hitbox_body_entered(_body):
	dir = -dir


func final_defeat_tween():
	print('this')
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", 0, 5) \
	.set_trans(Tween.TRANS_LINEAR) \
	.set_ease(Tween.EASE_IN_OUT)
	

func _on_player_projectile_hit():
	var current_state = state_machine.current_state
	
	if current_state.name != "Defeated" and current_state.name != "Incoming":
		health_component.struck_by_player_attack()
		hit_flash_component._on_hit()
