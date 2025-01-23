extends Area2D

@export var BlockColor: String

func _ready():
		$Sprite2D.texture = load("res://Textures/" + BlockColor + "_Block_on.png")

func toggleBlock(Toggle):
	if(Toggle):
		$CollisionShape2D.disabled = false
		$Sprite2D.texture = load("res://Textures/" + BlockColor + "_Block_on.png")
		$LightOccluder2D.visible = true
	else:
		$CollisionShape2D.disabled = true
		$Sprite2D.texture = load("res://Textures/" + BlockColor + "_Block_off.png")
		$LightOccluder2D.visible = false
