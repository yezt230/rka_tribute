extends AudioStreamPlayer2D

func play_random_pitch():
	pitch_scale = randf_range(2.0,2.6)
	play()
