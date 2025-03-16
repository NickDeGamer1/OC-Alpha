extends Area2D

#Lever that can be pulled

var active = false
@export var Output: String
@export var corroded: bool = false

func _ready():
	if (OptionsSingleton.Shadows != 0):#Graphics settings
		$red_light.visible = false
		$green_light.visible = false
		$red_light2.visible = false
		$green_light2.visible = false
	$Corrode.visible = corroded#If corroded
	$Corrode2.visible = corroded
	$Corrode3.visible = corroded


func interact():
	if !active and !corroded:#Flips lever when active and not corroded
		$Sprite2D.region_rect = Rect2(199, 1 ,32,32)
		leverOn()
		if (OptionsSingleton.Shadows == 0):
			$red_light.visible = false
			$red_light2.visible = false
			$green_light.visible = true
			$green_light2.visible = true
		active = true
		$AudioStreamPlayer2D.play()
	elif !corroded:#Flips lever back
		$Sprite2D.region_rect = Rect2(166, 1 ,32,32)
		leverOff()
		if (OptionsSingleton.Shadows == 0):
			$red_light.visible = true
			$red_light2.visible = true
			$green_light.visible = false
			$green_light2.visible = false
		active = false
		$AudioStreamPlayer2D.play()
	else:#Corroded
		$"../Party/Player/AudioStreamPlayer2D".play()

func setup(v : bool):
	if v:
		$Sprite2D.region_rect = Rect2(199, 1 ,32,32)
		leverOn()
		if (OptionsSingleton.Shadows == 0):
			$red_light.visible = false
			$red_light2.visible = false
			$green_light.visible = true
			$green_light2.visible = true
		active = true
	else:
		$Sprite2D.region_rect = Rect2(166, 1 ,32,32)
		leverOff()
		if (OptionsSingleton.Shadows == 0):
			$red_light.visible = true
			$red_light2.visible = true
			$green_light.visible = false
			$green_light2.visible = false
		active = false


#Toggles object
func leverOn():
	get_node("../" + Output + "Block").toggleBlock(false)

func leverOff():
	get_node("../" + Output + "Block").toggleBlock(true)


func clean():#Damian Cleans lever
	if corroded:
		for i in get_children():
			if i.name.contains("Corrode"):
				i.get_node("AnimationPlayer").play("clean")
		$AudioStreamPlayer2D2.play()
		await get_tree().create_timer(2.9).timeout
		corroded = false
