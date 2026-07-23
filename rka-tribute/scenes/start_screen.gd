extends CanvasLayer


func _ready():
	MusicPlayer.play_starting_music()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/rubbing_portion.tscn")
