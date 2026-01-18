extends State

@export var poised_up_state: State
@export var poised_down_state: State
@export var stifled_state: State

var	player_sprite
var	sprite_scale
var collision
var collision_coords

func enter() -> void:
	super()
	player_sprite = parent.player_sprite
	sprite_scale = parent.sprite_scale
	collision = parent.collision
	collision_coords = parent.collision_coords
	collision.global_position = Vector2(collision_coords.right, collision_coords.idle_y)
	parent.player_animations.play('idle_bounce')
	

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('up'):
		return poised_up_state
	elif Input.is_action_just_pressed('down'):
		return poised_down_state
	elif Input.is_action_just_pressed('left'):
		collision.global_position.x = collision_coords.right
		player_sprite.scale.x = sprite_scale * 1
		return poised_up_state
	elif Input.is_action_just_pressed('right'):
		collision.global_position.x = collision_coords.left
		player_sprite.scale.x = sprite_scale * -1
		return poised_up_state
	return null


func on_enemy_eaten():
	pass
