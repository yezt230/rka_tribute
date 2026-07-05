extends AudioStreamPlayer2D

@export var SoundArray: Array[AudioStream]

func play_jump_sound():
	if SoundArray == null or SoundArray.size() == 0:
		return
	
	# 50% chance to stay silent.
	if randf() < 0.3:
		return
	
	stream = SoundArray.pick_random()
	play()
