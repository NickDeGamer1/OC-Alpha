extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Neutral")
	await Pla.Diologue(GameSingleton.CharList[0], "Annoyed", "Annoyed")
	await Pla.Diologue(GameSingleton.CharList[0], "Angry", "Angry")
	await Pla.Diologue(GameSingleton.CharList[0], "Excited", "Excided")
	await Pla.Diologue(GameSingleton.CharList[0], "Happy", "Happy")
	await Pla.Diologue(GameSingleton.CharList[0], "Sad", "Sad")
	await Pla.Diologue(GameSingleton.CharList[0], "Scared", "Scared")
	await Pla.Diologue(GameSingleton.CharList[0], "Worried", "Worried")
	match GameSingleton.CharList[0]:
		"Alex":
			await Pla.Diologue(GameSingleton.CharList[0], "Truth", "Truth")
		"Faelyn":
			await Pla.Diologue(GameSingleton.CharList[0], "Colon3", "Colon3")
		"Glen4":
			await Pla.Diologue(GameSingleton.CharList[0], "Man", "Man")
			await Pla.Diologue(GameSingleton.CharList[0], "Broken", "Broken")
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

