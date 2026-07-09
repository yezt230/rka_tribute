extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]

func _ready() -> void:
	finished.connect(_on_finished)

func play_random() -> void:
	if streams.is_empty():
		return

	stream = streams.pick_random()
	play()

func _on_finished() -> void:
	play_random()
