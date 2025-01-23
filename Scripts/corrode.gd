extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if (OptionsSingleton.Shadows != 0):
		pass#$LightOccluder2D2.visible = false
