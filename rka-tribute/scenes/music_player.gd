extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]

func play_action_music():
	stream = streams[0]
	play()


func play_victory_music():
	stream = streams[1]
	play()


func play_starting_music():
	stream = streams[2]
	play()


func decrease_volume():
	volume_db -= 1.5
	
	
func reset_volume():
	volume_db = 0
