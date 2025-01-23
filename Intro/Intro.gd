extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_processor_name().contains("AMD Custom APU"):
		get_window().size = Vector2i(1280,800)
		OptionsSingleton.ConType = 3
	$Control/VideoStreamPlayer.play()
	$AnimationPlayer.play("LabelAppear")
	

func _input(event):
	if event.is_action_pressed("skip"):
		get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
