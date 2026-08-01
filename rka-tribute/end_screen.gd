extends Node2D


func _on_title_screen_button_pressed():
	universal_end_settings()
	

func _on_title_screen_relax_mode_button_pressed():
	GlobalVars.rubbing_enabled = false
	universal_end_settings()
	
	
func universal_end_settings():
	var bus_index := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_index, false)
	MusicPlayer.play_starting_music()
	get_tree().change_scene_to_file("res://scenes/rubbing_portion.tscn")
