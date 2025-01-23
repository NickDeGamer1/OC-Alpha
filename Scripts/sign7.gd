extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Mittens|[img=50]res://Textures/MittensIcon.png[/img]| is a Shapshifter, when over a gap they can become a bridge")
	if GameSingleton.CharList.size() > 3:
		if GameSingleton.CharList[0] != "Mittens":
			await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Im Sorry, Turn INTO a bridge?")
		else:
			await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Im Sorry, Turn INTO a bridge?")
		await Pla.Diologue("Mittens", "Neutral", "Yea, I can do that, Im a Shapeshifter")
		if GameSingleton.CharList[2] != "Mittens":
			await Pla.Diologue(GameSingleton.CharList[2], "Neutral", "That sounds broken...")
		else:
			await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "That sounds broken...")
		await Pla.Diologue("Mittens", "Neutral", "Oh trust me,")
		await Pla.Diologue("Mittens", "Neutral", "It absolutely is.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "While standing on the marked area, interact (E/|[img=50]" + loadCont("Face_Button_down") + "[/img]|) as Mittens|[img=50]res://Textures/MittensIcon.png[/img]| to become a bridge.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "If you are solo, then face the direction you would like to look (AD/|[img=50]" + loadCont("Analog_Stick_L_left") + "[/img]| |[img=50]" + loadCont("Analog_Stick_L_right") + "[/img]|) and press the ability button (space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|) to go to the side you would like")
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

