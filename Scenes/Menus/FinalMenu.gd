extends Control



func _on_cred_button_pressed():
	$CenterContainer2.visible = true


func _on_back_button_pressed():
	$CenterContainer2.visible = false


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
