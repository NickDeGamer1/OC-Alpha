extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Athena|[img=50]res://Textures/AthenaIcon.png[/img]| can use their wings to create gusts of winds to activate fans.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "While Facing the direction you would like (Arrow Keys/|[img=50]" + loadCont("Analog_Stick_R") + "[/img]|), press the ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|) to create a gust of wind.")
	await Pla.Diologue("Athena", "Neutral", "Oddly specific, but ok...")
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

