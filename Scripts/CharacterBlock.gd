extends Area2D

@onready var Pla = get_node("../../Party/Player")
@export var Character:String

func Open():#disables to let characters through
	visible = false
	$CollisionShape2D.disabled = true

func interact():#displays what character you need
	await Pla.NPCDiologue(null, "You need " + Character + "|[img=50]res://Textures/" + Character + "Icon.png[/img]| for this area.")
	Pla.EndDiologue()
