extends Node2D


func _on_title_screen_button_pressed():
	get_tree().change_scene_to_file("res://scenes/rubbing_portion.tscn")


func _on_title_screen_relax_mode_button_pressed():
	GlobalVars.rubbing_enabled = false
	#@todo global flag to allow infinite rubbing
	get_tree().change_scene_to_file("res://scenes/rubbing_portion.tscn")
