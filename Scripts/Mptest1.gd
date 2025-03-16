extends Node2D

#Script for MPTest1

@export var PlayerScene: PackedScene = load("res://Prefabs/Party.tscn")


#Sets up music and scene
func _ready():
	OptionsSingleton.lastScene = "res://Scenes/Menus/MainMenu.tscn"
	GameSingleton.Location = "Multiplayer Test Room"
	GameSingleton.music = "Trinity (Remastered)"

#Changes background
func _on_t_1_area_entered(area):
	if (area.name == "PlayerCollider") and $ParallaxBackground1.visible:
		$AnimationPlayer.play("Transition1")

func _on_t_2_area_entered(area):
	if (area.name == "PlayerCollider") and $ParallaxBackground2.visible:
		$AnimationPlayer.play("Transition2")
