extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Alex|[img=50]res://Textures/AlexIcon.png[/img]| can use Aurora|[img=50]res://Textures/AuroraIcon.png[/img]| to freeze the water")
	await Pla.NPCDiologue("res://Textures/Sign.png", "To use her, press the Ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|)")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Be aware, Aurora|[img=50]res://Textures/AuroraIcon.png[/img]| needs space in front of Alex|[img=50]res://Textures/AlexIcon.png[/img]| to appear.")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Luckily, you can use the arrow keys or |[img=50]" + loadCont("Analog_Stick_R") + "[/img]| to face in the direction you would like")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Or you can put your mouse on the tile you want to face and the character will face that direction")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Aurora|[img=50]res://Textures/AuroraIcon.png[/img]| will also turn left and right if there isn't a freezable space in front of her")
	await Pla.Diologue("Alex", "Neutral", "She's smart like that")
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
