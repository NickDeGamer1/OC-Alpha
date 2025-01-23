extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if OptionsSingleton.Touch:
		visible = true
	else:
		visible = false
