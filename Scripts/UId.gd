extends Control

func changeConDIS():
	match OptionsSingleton.ConType:
		0:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsXB.jpg")
		1:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsPS.jpg")
		2:
			$"../ControllerDisplay".texture = load("res://Textures/ControlsNS.jpg")
