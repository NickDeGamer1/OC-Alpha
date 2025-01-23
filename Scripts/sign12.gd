extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Damian|[img=50]res://Textures/DamianIcon.png[/img]| can use his holy water spray bottle against any corrosion to get rid of it.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Use the ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|) while facing the direction you would like to spray.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Some corrosion will come back after a while, so you'll need to act fast.")
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

