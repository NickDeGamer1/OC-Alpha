extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Shibe|[img=50]res://Textures/ShibeIcon.png[/img]| can also sniff for hidden paths that lead to buttons")
	await Pla.NPCDiologue("res://Textures/Sign.png", "just use the ability button (Space/|[img=50]" + loadCont("Face_Button_left") + "[/img]|)")
	await Pla.Diologue("Shibe", "Neutral", "I am a dog after all")
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

