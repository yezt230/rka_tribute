extends State

@onready var player = $"../.."
@onready var state_machine = $".."
@onready var anim_player = $"../../AnimationPlayer"

var return_state: State

func enter() -> void:
	# Cache the state we were interrupted from
	return_state = player.resolve_locomotion_state()

	anim_player.play("hurt")
	anim_player.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)

func exit() -> void:
	if anim_player.animation_finished.is_connected(_on_hurt_finished):
		anim_player.animation_finished.disconnect(_on_hurt_finished)

func _on_hurt_finished(_anim_name: String) -> void:
	state_machine.change_state(return_state)
