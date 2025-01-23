extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Mike|[img=50]res://Textures/MikeIcon.png[/img]| can interact with terminals to open doors")
	if GameSingleton.CharList[0] != "Mike":
		await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "You must be good with computers")
	else:
		await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "You must be good with computers")
	await Pla.Diologue("Mike", "Neutral", "Yup, i use arch btw")
	if GameSingleton.CharList[2] != "Mike":
		await Pla.Diologue(GameSingleton.CharList[2], "Neutral", "What does that even mean?")
	else:
		await Pla.Diologue(GameSingleton.CharList[3], "Neutral", "What does that even mean?")
	
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

