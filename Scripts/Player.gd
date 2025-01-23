extends CharacterBody2D

var moving = false
var cutscene = false
var solo = false
var vib = false
var swappable: bool = true
var tile_size = 96
var animation_speed = 4
@export var direction = "down"
var scene
var time = 0
var tempV:bool = true

var temppos
var lastpos1 = Vector2(0,0)


var spr
var occ
@onready var ray = $RayCast2D
@onready var aud = $AudioStreamPlayer2D
@onready var DiologeBox = get_node("../CLUI/SpeachBubble")
@onready var UI = get_node("../CLUI/UI/")
@onready var UIAnimL = get_node("../CLUI/UI/LeftAnimationPlayer")

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func _ready():
	loadSprite()
	
	set_zoom()

func set_zoom():
	var tween = create_tween()
	match OptionsSingleton.zoom:
		1:
			tween.tween_property($Camera2D, "zoom", Vector2(3,3), 0.33)
		2:
			tween.tween_property($Camera2D, "zoom", Vector2(1.5,1.5), 0.33)
		3:
			tween.tween_property($Camera2D, "zoom", Vector2(1,1), 0.33)
		4:
			tween.tween_property($Camera2D, "zoom", Vector2(0.75,0.75), 0.33)
		5:
			tween.tween_property($Camera2D, "zoom", Vector2(0.33,0.33), 0.33)

func _process(delta):
	if Input.is_action_pressed("move_up") and !moving and !cutscene:
		direction = "up"
		if (check("move_up")):
			move("move_up")
		else:
			spr.play("move_up")
			occ.occluder = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/Occluder/move_up1.tres")
			spr.stop()
			spr.face("move_up")
			updateCon("move_up", "Face_Button_down")
			rumble()
			if !aud.playing:
				aud.play()
	if Input.is_action_pressed("move_down") and !moving and !cutscene:
		direction = "down"
		if (check("move_down")):
			move("move_down")
		else:
			spr.play("move_down")
			occ.occluder = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/Occluder/move_down1.tres")
			spr.stop()
			spr.face("move_down")
			updateCon("move_down", "Face_Button_down")
			rumble()
			if !aud.playing:
				aud.play()
	if Input.is_action_pressed("move_left") and !moving and !cutscene:
		direction = "left"
		if (check("move_left")):
			move("move_left")
		else:
			spr.play("move_left")
			occ.occluder = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/Occluder/move_left1.tres")
			spr.stop()
			spr.face("move_left")
			updateCon("move_left", "Face_Button_down")
			rumble()
			if !aud.playing:
				aud.play()
	if Input.is_action_pressed("move_right") and !moving and !cutscene:
		direction = "right"
		if (check("move_right")):
			move("move_right")
		else:
			spr.play("move_right")
			occ.occluder = load("res://Prefabs/Characters/" + GameSingleton.CharList[0] + "/Occluder/move_right1.tres")
			spr.stop()
			spr.face("move_right")
			updateCon("move_right", "Face_Button_down")
			rumble()
			if !aud.playing:
					aud.play()
	if Input.is_action_pressed("face_up") and !moving and !cutscene:
		face("up")
	if Input.is_action_pressed("face_down") and !moving and !cutscene:
		face("down")
	if Input.is_action_pressed("face_left") and !moving and !cutscene:
		face("left")
	if Input.is_action_pressed("face_right") and !moving and !cutscene:
		face("right")
	time += delta
	
	if(time > 3):
		if(lastpos1 == position):
			UI.appear()
		lastpos1 = position
		time = 0

func ResetPos():
	position.x = position.x - (int(position.x) % tile_size)
	position.y = position.y - (int(position.y) % tile_size)

func _input(event):
	if event.is_action_pressed("ControllerInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif (event is InputEventMouseMotion) or event.is_action_pressed("KeyboardInput"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event.is_action_pressed("interact") and !cutscene and !moving:
		ray.target_position = inputs["move_" + direction] * tile_size
		ray.force_raycast_update()
		if ray.is_colliding() and ray.get_collider().has_method("interact"):
			ray.get_collider().interact()
	elif event.is_action_pressed("swap_character") and !cutscene and !moving and !solo and swappable:
		swap()
	elif event.is_action_pressed("rev_swap") and !cutscene and !moving and !solo and swappable:
		revSwap()
	elif event.is_action_pressed("ability") and !cutscene and !moving:
		Ability(GameSingleton.CharList[0])
	elif event.is_action_released("Pause"):
		$"../CLUI/PauseMenu".Pause()
	elif event.is_action_pressed("zoom_in"):
		OptionsSingleton.zoom -= 1
		if OptionsSingleton.zoom <= 0:
			OptionsSingleton.zoom = 1
		set_zoom()
	elif event.is_action_pressed("zoom_out"):
		OptionsSingleton.zoom += 1
		if OptionsSingleton.zoom >= 5:
			OptionsSingleton.zoom = 5
		set_zoom()
	elif event.is_action_pressed("Debug"):
		Debug()

func Ability(Char):
	cutscene = true
	await get_node("EncloseSPR/AnimatedSprite2D").Ability(Char, direction)
	cutscene = false

func face(dir):
	direction = dir
	spr.play("move_" + dir)
	spr.stop()
	spr.face("move_" + dir)
	updateCon("move_" + dir, "Face_Button_down")
	ray.target_position = inputs["move_" + direction] * tile_size
	ray.force_raycast_update()

func move(dir):
	moveN(dir)
	if(get_node_or_null("../PartyMember1") != null) and !solo:
		get_node("../PartyMember1").move()

func moveN(dir):
	UI.disappear()
	var tween = create_tween()
	spr.play(dir)
	tween.tween_property(self, "position",position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	moving = true
	await tween.finished
	stopAnim()
	updateCon(dir, "Face_Button_down")
	moving = false
	get_parent().emit_signal("moved")

func stopAnim():
	await get_tree().create_timer(0.1).timeout
	if(!moving):
		spr.stop()
		spr.face("move_" + direction)

func check(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	return !ray.is_colliding()

func loadSprite():
	if !MpManager.Multip:
		loadSpriteC(GameSingleton.CharList[0])

func loadSpriteC(Charname):
	if $EncloseSPR.has_node("AnimatedSprite2D"):
		$EncloseSPR.remove_child($EncloseSPR.get_node("AnimatedSprite2D"))
	var loc = "res://Prefabs/Characters/" + Charname + "/" + Charname + "Anim.tscn"
	scene = load(loc)
	var child_node = scene.instantiate()
	$EncloseSPR.add_child(child_node)
	spr = $EncloseSPR/AnimatedSprite2D
	occ = $EncloseSPR/AnimatedSprite2D/LightOccluder2D
	spr.updateshadow(Charname)
	aud.stream = load("res://Audio/Bonk" + Charname + ".wav")
	face(direction)

func swap():
	if GameSingleton.CharList.size() >= 2:
		swapanim()
		cutscene = true
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").cut(true)
		visible = false
		get_node("../TempSprite").position = position
		get_node("../TempSprite").loadSprite(GameSingleton.CharList[0])
		
		if tempV:
			get_node("../TempSprite").visible = true
		
		temppos = position
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").settemppos()
		
		for n in range(GameSingleton.CharList.size()):#loops
			if(get_node_or_null("../PartyMember" + str(n+1)) != null):
				get_node("../PartyMember" + str(n+1)).moveN(get_node("../PartyMember" + str(n+1)).CheckPosN("TempSprite"))
				await get_node("../TempSprite").moveN(opp(get_node("../PartyMember" + str(n+1)).CheckPosN("TempSprite")))
		
		
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").returntemppos()
		position = temppos
		
		GameSingleton.swapChar()#do whis when anim done
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").swap()
		loadSpriteC(GameSingleton.CharList[0])
		visible = true
		get_node("../TempSprite").visible = false
		if get_node_or_null("../../DiscordManager") != null:
			$"../../DiscordManager".Update()
		#await get_tree().create_timer(.1).timeout
		cutscene = false
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").cut(false)
	else:
		aud.play()

func revSwap():
	if GameSingleton.CharList.size() >= 2:
		revswapanim()
		cutscene = true
		if(get_node("../PartyMember1") != null):
				get_node("../PartyMember1").cut(true)
		
		temppos = position
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").settemppos()
		
		for n in range(GameSingleton.CharList.size()):#loops
			if(get_node_or_null("../PartyMember" + str(GameSingleton.CharList.size() - n)) != null and get_node_or_null("../PartyMember" + str(GameSingleton.CharList.size() - n - 1)) != null):
				$"../TempSprite".position = get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).position
				get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).moveN(get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).CheckPosN("PartyMember" + str(GameSingleton.CharList.size() - n - 1)))
				await get_node("../PartyMember" + str(GameSingleton.CharList.size() - n - 1)).moveN(get_node("../PartyMember" + str(GameSingleton.CharList.size() - n - 1)).CheckPosN("TempSprite"))
		visible = false
		get_node("../TempSprite").position = position
		get_node("../TempSprite").loadSprite(GameSingleton.CharList[0])
		get_node("../TempSprite").visible = true
		
		$"../TempSprite2".position = get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).position
		get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).moveN(get_node("../PartyMember" + str(GameSingleton.CharList.size() - 1)).CheckPosN("Player"))
		await get_node("../TempSprite").moveN(get_node("../TempSprite").CheckPosN("../TempSprite2"))
		
		GameSingleton.revSwapChar()
		
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").returntemppos()
		position = temppos
		
		
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").swap()
		loadSprite()
		
		visible = true
		get_node("../TempSprite").visible = false
		
		if get_node_or_null("../../DiscordManager") != null:
			$"../../DiscordManager".Update()
		#await get_tree().create_timer(.1).timeout
		cutscene = false
		if(get_node("../PartyMember1") != null):
			get_node("../PartyMember1").cut(false)
	else:
		aud.play()

func swapanim():
	if UI.LUIonscreen == false:
		UIAnimL.play("Swap")
		UI.LUIonscreen = true
	else:
		UIAnimL.play("OFSCSwap")

func revswapanim():
	if UI.LUIonscreen == false:
		UIAnimL.play("RSwap")
		UI.LUIonscreen = true
	else:
		UIAnimL.play_backwards("OFSCRSwap")

func CheckPos(n):
	var checkNode = get_node("../PartyMember" + str(n))
	if (global_position.x == checkNode.global_position.x):
		if(global_position.y > checkNode.global_position.y):
			direction = "up"
			return "move_up"
		else:
			direction = "down"
			return "move_down"
	else:
		if(global_position.x > checkNode.global_position.x):
			direction = "left"
			return "move_left"
		else:
			direction = "right"
			return "move_right"

func opp(Inp):
	match Inp:
		"move_up":
			return "move_down"
		"move_down":
			return "move_up"
		"move_left":
			return "move_right"
		"move_right":
			return "move_left"

func Diologue(Char,emo,inp):
	cutscene = true
	await DiologeBox.updateText(Char,emo,inp)

func DiologueE(Char,emo,inp):
	cutscene = true
	await DiologeBox.updateTextE(Char,emo,inp)

func NPCDiologue(FileName, inp):
	cutscene = true
	await DiologeBox.NPupdateText(FileName,inp)

func NPCDiologueE(FileName, inp):
	cutscene = true
	await DiologeBox.NPupdateTextE(FileName,inp)

func EndDiologue():
	DiologeBox.CloseDio()
	await DiologeBox.get_node("AnimationPlayer").animation_finished
	cutscene = false


func _on_left_mouse_entered():
	if(!moving and !cutscene):
		face("left")
		if ray.is_colliding() and ray.get_collider().has_method("interact"):
			Input.set_custom_mouse_cursor(load("res://Textures/MouseWithExc.png"))

func _on_right_mouse_entered():
	if(!moving and !cutscene):
		face("right")
		if ray.is_colliding() and ray.get_collider().has_method("interact"):
			Input.set_custom_mouse_cursor(load("res://Textures/MouseWithExc.png"))

func _on_up_mouse_entered():
	if(!moving and !cutscene):
		face("up")
		if ray.is_colliding() and ray.get_collider().has_method("interact"):
			Input.set_custom_mouse_cursor(load("res://Textures/MouseWithExc.png"))

func _on_down_mouse_entered():
	if(!moving and !cutscene):
		face("down")
		if ray.is_colliding() and ray.get_collider().has_method("interact"):
			Input.set_custom_mouse_cursor(load("res://Textures/MouseWithExc.png"))

func _on_left_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Textures/OC mouse.png"))

func _on_right_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Textures/OC mouse.png"))

func _on_up_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Textures/OC mouse.png"))

func _on_down_mouse_exited():
	Input.set_custom_mouse_cursor(load("res://Textures/OC mouse.png"))

func rumble():
	if (OptionsSingleton.Rumble and !vib):
		vib = true
		match GameSingleton.CharList[0]:
			"Alex":
				Input.start_joy_vibration(0,.5,.5,.217)
			"Athena":
				await get_tree().create_timer(.14).timeout
				Input.start_joy_vibration(0,.8,.8,.05)
				await get_tree().create_timer(.22).timeout
				Input.start_joy_vibration(0,.8,.8,.05)
			"Mike":
				await get_tree().create_timer(.14).timeout
				Input.start_joy_vibration(0,.8,.8,.35)
				await get_tree().create_timer(.35).timeout
				Input.start_joy_vibration(0,.5,.5,.15)
			"Vex":
				await get_tree().create_timer(.07).timeout
				Input.start_joy_vibration(0,.5,.5,.1)
				await get_tree().create_timer(.15).timeout
				Input.start_joy_vibration(0,.5,.5,.15)
			"Shibe":
				Input.start_joy_vibration(0,.5,.5,.1)
				await get_tree().create_timer(.2).timeout
				Input.start_joy_vibration(0,.5,.5,.1)
				await get_tree().create_timer(.3).timeout
				Input.start_joy_vibration(0,.5,.5,.15)
			"Mittens":
				Input.start_joy_vibration(0,.5,.5,.217)
			"Faelyn":
				Input.start_joy_vibration(0,.6,.6,.46)
				await get_tree().create_timer(.61).timeout
				Input.start_joy_vibration(0,.6,.6,.14)
		vib = false

func updateCon(dir, inp):
	check(dir)
	ray.force_raycast_update()
	if ray.is_colliding() and ray.get_collider().has_method("interact"):
		$ControllerIcon.Display(inp)
	else:
		$ControllerIcon.hide()

func Debug():
	pass
	#cutscene = true
	#$AnimationPlayer.play("Jump")
	#await $AnimationPlayer.animation_finished
	#cutscene = false
