extends ColorRect
var ID:int
var UpdtateTime:float 


func Setup(id):
	ID = id
	if id == 1:
		$MarginContainer2/HBoxContainer/TextureRect.visible = true
	else:
		$MarginContainer2/HBoxContainer/TextureRect.visible = false
	
	if MpManager.MPhost:
		if ID != MpManager.id:
			$MarginContainer2/HBoxContainer/KickButton.visible = true
		else:
			$MarginContainer2/HBoxContainer/KickButton.visible = false
	else:
		$MarginContainer2/HBoxContainer/KickButton.visible = false
	
	for i in MpManager.Players:
		if MpManager.Players[i].id == id:
			$MarginContainer/Label.text = MpManager.Players[i].name
			$MarginContainer2/HBoxContainer/TextureRect3.texture = load("res://Textures/" + MpManager.Players[i].CC + "Icon.png")

func kickVisible():
	$MarginContainer2/HBoxContainer/KickButton.visible = true

func UpdatePing(time:float):
	$MarginContainer2/HBoxContainer/Label.text = str(time)
	if time < 35:
		$MarginContainer2/HBoxContainer/PingDisplayGreat.visible = true
		$MarginContainer2/HBoxContainer/PingDisplayOK.visible = false
		$MarginContainer2/HBoxContainer/PingDisplayPoor.visible = false
	elif time < 70:
		$MarginContainer2/HBoxContainer/PingDisplayGreat.visible = false
		$MarginContainer2/HBoxContainer/PingDisplayOK.visible = true
		$MarginContainer2/HBoxContainer/PingDisplayPoor.visible = false
	else:
		$MarginContainer2/HBoxContainer/PingDisplayGreat.visible = false
		$MarginContainer2/HBoxContainer/PingDisplayOK.visible = false
		$MarginContainer2/HBoxContainer/PingDisplayPoor.visible = true

func _on_kick_button_pressed():
	get_node("../../../../../../../MultiplayerManager").KickPlayer(ID)
