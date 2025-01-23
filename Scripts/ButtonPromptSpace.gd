extends Area2D

@onready var Ico = get_node("../Party/Player/ControllerIcon")
@export var CharNeeded:String
@export var Outputs = []
var looping:bool = false

func _on_area_entered(area):
	if area.name == "PlayerCollider" and CharNeeded == GameSingleton.CharList[0]:
		looping = true
		var i:int = 0
		while looping:
			Ico.Display(Outputs[i])
			await get_tree().create_timer(.5).timeout
			i+=1
			if i >= Outputs.size():
				i = 0
	elif area.name == "PlayerCollider":
		looping = true
		var i:int = 0
		while looping:
			Ico.DisplayC(CharNeeded)
			await get_tree().create_timer(.5).timeout
			i+=1
			if i >= Outputs.size():
				i = 0

func _on_area_exited(area):
	if (area.name == "PlayerCollider"):
		looping = false
		Ico.Hide()
