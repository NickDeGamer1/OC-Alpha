extends Area2D

@onready var Pla = get_node("../../Party/Player")
@export var Character:String

func Open():
	visible = false
	$CollisionShape2D.disabled = true

func interact():
	await Pla.NPCDiologue(null, "You need " + Character + "|[img=50]res://Textures/" + Character + "Icon.png[/img]| for this area.")
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
