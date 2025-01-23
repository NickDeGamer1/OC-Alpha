extends Node2D

@export var num: int = 1

func Play():
	$SpeakerR.play("Play")
	$SpeakerL.play("Play")
	var rand = RandomNumberGenerator.new()
	var t = rand.randi_range(1,100)
	if t == 69:
		$AudioStreamPlayer2D1.stream = load("res://Audio/weezer-buddy-holly-lick.mp3")
		$AudioStreamPlayer2D2.stream = load("res://Audio/weezer-buddy-holly-lick.mp3")
	else:
		$AudioStreamPlayer2D1.stream = load("res://Audio/BonkVex.wav")
		$AudioStreamPlayer2D2.stream = load("res://Audio/BonkVex.wav")
	$AudioStreamPlayer2D1.play()
	$AudioStreamPlayer2D2.play()
	if OptionsSingleton.ScreenShake:
		get_node("../Party/Player/AnimationPlayer").play("Camera_shake")
	get_tree().call_group("Box", "Break")
	await $AudioStreamPlayer2D2.finished
	if OptionsSingleton.ScreenShake:
		get_node("../Party/Player/AnimationPlayer").play("Camera_RESET")
	$SpeakerR.play("RESET")
	$SpeakerL.play("RESET")
