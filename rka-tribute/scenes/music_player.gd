extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]

func play_action_music():
	stream = streams[0]
	play()


func play_victory_music():
	stream = streams[1]
	play()
