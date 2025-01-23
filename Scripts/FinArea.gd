extends Area2D
@onready var Pla = get_node("../Party/Player")

func _on_area_entered(area):
	if (area.name == "PlayerCollider") and !Pla.cutscene:
		Pla.cutscene = true
		get_node("../Party/CLUI/ColorRect/AnimationPlayer").play("FadeToBlack")
		await get_node("../Party/CLUI/ColorRect/AnimationPlayer").animation_finished
		GameSingleton.musicTime = Pla.get_node("MusicPlayer").get_playback_position()
		get_tree().change_scene_to_file("res://Scenes/Levels/test2.tscn")
