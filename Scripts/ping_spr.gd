extends Sprite2D

@export var ID:int


func Set_color(InpC):
	print(InpC)
	self_modulate = Color(InpC.r, InpC.g, InpC.b, .75)

func Appear(id, inp):
	if id == ID:
		global_position = inp
		$AnimationPlayer.play("appear")
