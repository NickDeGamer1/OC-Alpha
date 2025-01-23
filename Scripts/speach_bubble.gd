extends Control

@onready var Distext = $NinePatchRect/MarginContainer/HBoxContainer/DisText
@onready var Chatext = $NameRect/MarginContainer/CharText
@onready var Pic = $NinePatchRect/MarginContainer/HBoxContainer/TextureRect
var scrolling
signal Finished
var EndTexts = false
var numberinArray:int
var Text1:bool = true
var Text2:bool = true

func _ready():
	pass

func appear():
	Distext.text = ""
	visible = true
	$AnimationPlayer.play("Appear")
	await $AnimationPlayer.animation_finished

func disapear():
	$AnimationPlayer.play("Disappear")
	await $AnimationPlayer.animation_finished
	visible = false
	Distext.text = ""
	Chatext.text = ""

func updateText(ChInp,emo,inp):
	Pic.texture = load("res://Prefabs/Characters/" + ChInp + "/TextSprites/" + ChInp + emo + ".png")
	if Pic.texture == null:
		Pic.texture = load("res://Prefabs/Characters/" + ChInp + "/TextSprites/" + ChInp + "Image.jpeg")
	
	numberinArray = GameSingleton.CharList.find(ChInp, 0)
	
	startDio(numberinArray)
	get_node("../../Player/DioPlayer").stream = load("res://Audio/"+ ChInp + "Sound.wav")
	if get_node("../../Player/DioPlayer").stream == null:
		get_node("../../Player/DioPlayer").stream = load("res://Audio/text.wav")
	
	Distext.text = ""
	$NameRect.visible = true
	Chatext.text = ChInp
	await updateJustText(inp, true)

func updateTextE(ChInp,_emo,inp):
	Pic.texture = load("res://Prefabs/Characters/" + ChInp + "/TextSprites/" + ChInp + "Image.jpeg")
	Distext.text = ""
	$NameRect.visible = true
	Chatext.text = ChInp
	await updateJustText(inp, false)

func NPupdateText(File, inp):
	$NameRect.visible = false
	Distext.text = ""
	if (File != null):
		Pic.texture = load(File)
	else:
		Pic.texture = null
	await updateJustText(inp, true)

func NPupdateTextE(File, inp):
	$NameRect.visible = false
	Distext.text = ""
	if (File != null):
		Pic.texture = load(File)
	else:
		Pic.texture = null
	await updateJustText(inp, false)

func updateJustText(inp: String, e: bool):
	$NinePatchRect/Arrow.visible = false
	var DispText:String
	if !visible:
		appear()
		await $AnimationPlayer.animation_finished
	var let = 0
	scrolling = true
	while (let < inp.length()):
		if inp[let] == '[' and Text2:
			Text1 = false
		elif inp[let] == ']' and Text2:
			Text1 = true
		if inp[let] == '|':
			print(true)
			if Text2:
				Text2 = false
			else:
				Text2 = true
		
		if Text1 and Text2 and inp[let] != '|':
			DispText = DispText + inp[let]
			Distext.text = DispText
			if inp[let] != ' ':
				get_node("../../Player/DioPlayer").play()
			await get_tree().create_timer(.05).timeout
		else:
			if inp[let] != '|':
				DispText = DispText + inp[let]
		
		let+=1
		if (EndTexts):
			EndTexts = false
			let = inp.length()
			Distext.text = ""
			var i:int = 0
			var temp:String = ""
			while i < inp.length():
				if inp[i] != '|':
					temp = temp + inp[i]
				i+=1
			Distext.text = temp
			endDio(numberinArray)
		
	scrolling = false
	get_node("../../Player/DioPlayer").stream = load("res://Audio/text.wav")
	endDio(numberinArray)
	if e:
		await get_tree().create_timer(.5).timeout
		$NinePatchRect/Arrow.visible = true
		$AnimationPlayer.play("Wait")
		await Signal(self, 'Finished')
	

func _input(event):
	if event.is_action_pressed("skip"):
		if scrolling and visible:
			skipText()
		elif visible:
			end()

func startDio(n):
	
	if get_node_or_null("../../Player") != null and numberinArray >= 0:
		match n:
			0:
				if get_node("../../Player").direction != "up":
					get_node("../../Player/EncloseSPR/AnimatedSprite2D/AnimationPlayer").play("Talking_" + get_node("../../Player").direction)
			_:
				if get_node("../../PartyMember"+ str(numberinArray)).direction != "up":
					get_node("../../PartyMember"+ str(numberinArray) + "/AnimatedSprite2D/AnimationPlayer").play("Talking_" + get_node("../../PartyMember"+ str(numberinArray)).direction)

func loadCont(But:String):
	var outp:String = "res://Textures/ControllerButtons/"
	match OptionsSingleton.ConType:
		0:#Xbox
			outp = outp + "XB/"
		1:#Playstation
			outp = outp + "PS/"
		2:#Switch
			outp = outp + "SW/"
		3:#Steam Deck
			outp = outp + "SD/"
		_:
			outp = outp + "XB/"
	
	return outp + But + ".png"

func endDio(n):
	if get_node_or_null("../../Player/EncloseSPR/AnimatedSprite2D/AnimationPlayer") != null and numberinArray >= 0:
		match n:
			0:
				get_node("../../Player/EncloseSPR/AnimatedSprite2D/AnimationPlayer").stop()
				get_node("../../Player/EncloseSPR/AnimatedSprite2D/Mouth").visible = false
				get_node("../../Player/EncloseSPR/AnimatedSprite2D/MouthL").visible = false
				get_node("../../Player/EncloseSPR/AnimatedSprite2D/MouthR").visible = false
			_:
				get_node("../../PartyMember"+ str(numberinArray) + "/AnimatedSprite2D/AnimationPlayer").stop()
				get_node("../../PartyMember"+ str(numberinArray) + "/AnimatedSprite2D/Mouth").visible = false
				get_node("../../PartyMember"+ str(numberinArray) + "/AnimatedSprite2D/MouthL").visible = false
				get_node("../../PartyMember"+ str(numberinArray) + "/AnimatedSprite2D/MouthR").visible = false

func end():
	Finished.emit()

func skipText():
	EndTexts = true

func CloseDio():
	disapear()
