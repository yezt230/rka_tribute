extends AudioStreamPlayer2D

func play_jump_sound():
	if randf() < 0.3:
		return
	play()
