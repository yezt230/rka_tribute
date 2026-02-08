extends State

@onready var player = $"../.."
@onready var state_machine = $".."
@onready var anim_player = $"../../AnimationPlayer"
@export var knockback_force: float = 200.0

var preserved_vertical_velocity: float

var return_state: State

func enter() -> void:
	# Preserve vertical momentum
	preserved_vertical_velocity = player.velocity.y

	# Apply horizontal knockback
	player.apply_knockback(knockback_force)

	# Restore vertical velocity exactly
	player.velocity.y = preserved_vertical_velocity

	anim_player.play("hurt")
	anim_player.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)


func physics_process(_delta: float) -> void:
	# NO INPUT HANDLING
	# Gravity is still applied by Player._physics_process()
	pass
	
	
func exit() -> void:
	if anim_player.animation_finished.is_connected(_on_hurt_finished):
		anim_player.animation_finished.disconnect(_on_hurt_finished)
	
	
func _on_hurt_finished(_anim_name: String) -> void:
	state_machine.change_state(player.resolve_locomotion_state())
