extends Area2D

@export_enum("Down", "Up", "Left", "Right") var direction = "Down"
@export var BlockToToggle:Node
@export var Quick = false
# Called when the node enters the scene tree for the first time.
func _ready():
	match direction:
		"Down":
			$Sprite2D.texture = load("res://Textures/Cumpooper_down.png")
		"Up":
			$Sprite2D.texture = load("res://Textures/Cumpooper_up.png")
		"Left":
			$Sprite2D.texture = load("res://Textures/Cumpooper_side.png")
		"Right":
			$Sprite2D.texture = load("res://Textures/Cumpooper_side.png")
			$Sprite2D.flip_h = true
		_:
			$Sprite2D.texture = load("res://Textures/Cumpooper_down.png")

func interact():
	if GameSingleton.CharList[0] == "Mike":
		get_node("../Party/Player").cutscene = true
		$AnimationPlayer.play("TurnOn")
		await $AnimationPlayer.animation_finished
		if !Quick:
			await get_node("../Party/CLUI/MikeMiniUI").start()
			if get_node_or_null("../MultiplayerManager") != null:
				get_node_or_null("../MultiplayerManager").rpc("ExitPC", name)
		else:
			await get_tree().create_timer(1).timeout
		$AnimationPlayer.play("TurnOff")
		await $AnimationPlayer.animation_finished
		if BlockToToggle != null:
			BlockToToggle.toggleBlock(false)
		get_node("../Party/Player").cutscene = false
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, _ID):
	if Chr == "Mike":
		$AnimationPlayer.play("TurnOn")
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()
