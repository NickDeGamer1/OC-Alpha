extends Sprite2D

#Sets controller icon

var cont:String

func _ready():
	if OptionsSingleton.UseCon:
		match OptionsSingleton.ConType:
			0:
				cont = "XB/"
			1:
				cont = "PS/"
			2:
				cont = "SW/"
			3:
				cont = "SD/"
			_:
				cont = "XB/"

func Display(inp:String):
	if OptionsSingleton.UseCon:
		scale = Vector2(1,1)
		visible = true
		texture = load("res://Textures/ControllerButtons/" + cont + inp + ".png")
		$AnimationPlayer.play("Idol")

func DisplayC(inp:String):
	if OptionsSingleton.UseCon:
		scale = Vector2(0.1,0.1)
		visible = true
		texture = load("res://Textures/" + inp + "Icon.png")
		$AnimationPlayer.play("IdolC")

func Hide():
	if OptionsSingleton.UseCon:
		visible = false
		$AnimationPlayer.stop()
