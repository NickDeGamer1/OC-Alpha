extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Faelyn|[img=50]res://Textures/FaelynIcon.png[/img]| can use her voice to break glass walls")
	if GameSingleton.CharList[1] != "Faelyn":
		await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Wait Really?")
	else:
		await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Wait Really?")
	await Pla.NPCDiologue("res://Textures/Sign.png", "While close to a glass object press and hold the Ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|) and use WS/Arrow keys/|[img=50]" + loadCont("Dpad_up") + "[/img]| and |[img=50]" + loadCont("Dpad_down") + "[/img]| to change pitch")
	await Pla.NPCDiologue("res://Textures/Sign.png", "The glass will vibrate faster as it reaches it breaking point")
	if GameSingleton.CharList[2] != "Faelyn":
		await Pla.Diologue(GameSingleton.CharList[2], "Neutral", "Will this destroy our eardrums?")
	else:
		await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Will this destroy our eardrums?")
	await Pla.Diologue("Faelyn", "Neutral", "Only one way to find out!")

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
