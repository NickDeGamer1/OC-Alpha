extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Vex|[img=50]res://Textures/VexIcon.png[/img]| can use his guitar to break wooden boxes.")
	await Pla.Diologue("Vex", "Neutral", "Please tell me I use those big speakers!")
	await Pla.NPCDiologue("res://Textures/Sign.png", "As Vex|[img=50]res://Textures/VexIcon.png[/img]|, stand in between the speakers and press the ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|)")
	await Pla.Diologue("Vex", "Neutral", "YEEEEEEEAAAAAAAAAA BAAAAAAABYYYYYYYYYY!")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Be aware this creates alot of noise, so make sure to have your system volume down before you use it")
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

