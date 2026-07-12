extends AudioStreamPlayer2D

@export var SoundArray: Array[AudioStream]

func play_jump_sound():
	if randf() < 0.3:
		return
	play()
