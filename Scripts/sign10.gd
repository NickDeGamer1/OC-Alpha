extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Shibe|[img=50]res://Textures/ShibeIcon.png[/img]| can use brute force to push the logs away!")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Just Interact (E/|[img=50]" + loadCont("Face_Button_down") + "[/img]|) with the log to push it.")
	await Pla.Diologue("Shibe", "Neutral", "Nah, I got a better idea...")
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

