extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Mike|[img=50]res://Textures/MikeIcon.png[/img]| can also use the spool to connect wires")
	await Pla.NPCDiologue("res://Textures/Sign.png", "Interact with the spool to start moving the wire, be aware that the wire can only go so far")
	await Pla.Diologue("Mike", "Neutral", "I'm good at cable management, Dont worry!")
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

