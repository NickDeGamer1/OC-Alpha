extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Glen-4|[img=50]res://Textures/Glen4Icon.png[/img]|can use their brute force to punch holes in cracked walls")
	await Pla.NPCDiologue("res://Textures/Sign.png", "just press the ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|) while facing the direction you would like.")
	if GameSingleton.CharList[0] != "Glen4":
		await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Well, good thing your on our side.")
	else:
		await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Well, good thing your on our side.")
	await Pla.Diologue("Glen4", "Neutral", "I do not have the drivers to turn on you guys anyway.")
	if GameSingleton.CharList.has("Alex"):
		await Pla.Diologue("Glen4", "Neutral", "I might drop kick the green kid if prompted however")
		await Pla.Diologue("Alex", "Scared", "[shake rate=30.0 level=5 connected=1]wha-what?[/shake]")
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

