extends State

func enter() -> void:
	super()
	print("static state")
	parent.animation_player.play("jump_onto_cart")
	parent.player_can_move = false
	parent.jump_onto_cart_flag = true
