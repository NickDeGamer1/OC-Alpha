extends HBoxContainer

@onready var NameLabel = $MarginContainer/Label
@onready var SelfSpr = $HBoxContainer/MarginContainer/TextureRect
# Called when the node enters the scene tree for the first time.

func setup(PlayerName, Char):
	NameLabel.text = PlayerName
	loadSprite(Char)

func loadSprite(Charname):
	if has_node("AnimatedSprite2D"):
		remove_child(self.get_node("AnimatedSprite2D"))
	var loc = "res://Prefabs/Characters/" + Charname + "/" + Charname + "Anim.tscn"
	var scene = load(loc)
	var child_node = scene.instantiate()
	add_child(child_node)
	var Spr = $AnimatedSprite2D
	Spr.visible = false
	SelfSpr.texture = Spr.sprite_frames.get_frame_texture("move_down", 0)
