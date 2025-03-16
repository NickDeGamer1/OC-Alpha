extends Node2D

#-Removed HeroFaelyn

@onready var anim = $AnimatedSprite2D
var direction= "down"
var moving = false
var cutscene = true

func _ready():
	anim.face("move_down")
	if OptionsSingleton.Shadows == 1:
		$PointLight2D.visible = false
		$PointLight2D2.visible = false


func _on_area_2d_area_entered(area):
	match area.name:
		"Up":
			queue_free()
		"Down":
			queue_free()
		"Left":
			queue_free()
		"Right":
			queue_free()
