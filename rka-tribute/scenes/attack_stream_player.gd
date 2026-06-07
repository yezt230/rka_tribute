extends AudioStreamPlayer2D

@export var SoundArray: Array[AudioStream]

func play_attack_sound():
	if SoundArray == null || SoundArray.size() == 0:
		return
	
	stream = SoundArray.pick_random()
	#stream = SoundArray[0]
	play()

	
