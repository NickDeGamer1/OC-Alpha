extends Area2D

#Faelyn's sing radius

var active: bool = false
var octive = 3

var GlassObj = []

@onready var anim = $AnimationPlayer
@onready var aud = $AudioStreamPlayer2D
@onready var plaAnim = $"../"

signal end

func RemoveObj():#Clears list of GlassObj
	GlassObj = []

func Activate():#Start looking for walls
	active = true
	visible = true
	if OptionsSingleton.Touch:
		get_node("../../CLUI/TouchUI/Move_Buttons").visible = false
		get_node("../../CLUI/TouchUI/Pitch_Buttons").visible = true
	$CollisionShape2D.disabled = false
	plaAnim.play("Sing")
	anim.play("Play")
	aud.play()
	for entity in get_overlapping_areas(): 
		if entity.name.contains("GlassWall"):
			GlassObj.push_back(entity)
	await Signal(self, 'end')

func _input(event):#if singing, listen for pitch changes
	if !get_node("../../../").name.contains("MP") and GameSingleton.CharList.has("Faelyn") and active:
		if event.is_action_pressed("Pitch_up") and active:
			Pitch("up")
		elif event.is_action_pressed("Pitch_down") and active:
			Pitch("down")
		if event.is_action_released("ability") and active:
			endSing()


func Pitch(dir):#Sets new pitch
	if dir == "up":
		octive+=1
		if (octive > 5):
			octive = 5
		else:
			updatePitch(octive)
			if get_node_or_null("../../../../../MultiplayerManager") != null:
				get_node("../../../../../MultiplayerManager").PitchUpL(octive)
	else:
		octive-=1
		if (octive < 1):
			octive = 1
		else:
			updatePitch(octive)
			if get_node_or_null("../../../../../MultiplayerManager") != null:
				get_node("../../../../../MultiplayerManager").PitchDownL(octive)

func endSing():#Stops singing
	visible = false
	active = false
	sendExit()
	RemoveObj()
	anim.stop()
	aud.stop()
	anim.play("RESET")
	octive = 3
	aud.pitch_scale = 1
	anim.speed_scale = 1
	end.emit()
	if get_node_or_null("../../../../../MultiplayerManager") != null:
		get_node("../../../../../MultiplayerManager").endSingL()

func updatePitch(Scale):#Sets pitch of audio and anim
	var tween = create_tween()
	match Scale:
		1:
			tween.tween_property(aud, "pitch_scale", .25, .5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(anim, "speed_scale", .25, .5).set_trans(Tween.TRANS_LINEAR)
			plaAnim.play("Sing_down_End")
		2:
			tween.tween_property(aud, "pitch_scale", .5, .5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(anim, "speed_scale", .5, .5).set_trans(Tween.TRANS_LINEAR)
			plaAnim.play("Sing_down")
		3:
			tween.tween_property(aud, "pitch_scale", 1, .5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(anim, "speed_scale", 1, .5).set_trans(Tween.TRANS_LINEAR)
			plaAnim.play("Sing")
		4:
			tween.tween_property(aud, "pitch_scale", 2, .5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(anim, "speed_scale", 2, .5).set_trans(Tween.TRANS_LINEAR)
			plaAnim.play("Sing_up")
		5:
			tween.tween_property(aud, "pitch_scale", 4, .5).set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(anim, "speed_scale", 4, .5).set_trans(Tween.TRANS_LINEAR)
			plaAnim.play("Sing_up_End")
	sendOct()

func sendOct():#Broadcasts pitch
	for Glass in GlassObj:
		Glass.Break(octive)

func sendExit():#Broadcasts end
	for Glass in GlassObj:
		Glass.exit()
