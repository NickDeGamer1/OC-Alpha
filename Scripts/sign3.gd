extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Alex|[img=50]res://Textures/AlexIcon.png[/img]| can also use Aurora|[img=50]res://Textures/AuroraIcon.png[/img]| to climb into Vents")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Interact (E/|[img=50]" + loadCont("Face_Button_down") + "[/img]|) with the vent as Alex to use Aurora")
	Pla.EndDiologue()

func loadCont(But:String):
	var outp:String = "res://Textures/ControllerButtons/"
	match OptionsSingleton.ConType:
		0:#Xbox
			outp = outp + "XB/"
		1:#Playstation
			outp = outp + "PS/"
		2:#Switch
			outp = outp + "SW/"
		3:#Steam Deck
			outp = outp + "SD/"
		_:
			outp = outp + "XB/"
	
	return outp + But + ".png"
