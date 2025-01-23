extends Area2D

@export var BlockToToggle:Node

func interact():
	if get_node("../Spool").active:
		get_node("../Spool/Line2D").add_point(global_position - get_node("../Spool").global_position)
		get_node("../Spool/AudioStreamPlayer2D").play()
		$Sprite2D2.visible = true
		$LightOccluder2D.visible = true
		get_node("../Spool").active = false
		get_node("../Spool").complete = true
		get_node("../Party/Player").swappable = true
		if BlockToToggle!= null:
			BlockToToggle.toggleBlock(false)
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, _id):
	if get_node("../Spool").active and Chr == "Mike":
		get_node("../Spool/Line2D").add_point(global_position - get_node("../Spool").global_position)
		get_node("../Spool/AudioStreamPlayer2D").play()
		$Sprite2D2.visible = true
		$LightOccluder2D.visible = true
		get_node("../Spool").active = false
		get_node("../Spool").complete = true
		if BlockToToggle!= null:
			BlockToToggle.toggleBlock(false)
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func resetwire():
	$Sprite2D2.visible = false
	$LightOccluder2D.visible = false
	get_node("../ToggleBlock3").toggleBlock(true)
