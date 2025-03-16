extends Node2D

@onready var Pla = $Party/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	OptionsSingleton.lastScene = "res://Scenes/Levels/test2.tscn"
	
	GameSingleton.Location = "Test2"
	var music: String
	
	if OptionsSingleton.Hypercam2:#If hypercam, play music
		get_node("Party/Player/MusicPlayer").stream = load("res://Audio/Trinity (Remastered).wav")
		$Party/CLUI/Hypercam.visible = true
		music = "Trinity (Remastered)"
	else:
		get_node("Party/Player/MusicPlayer").stream = load("res://Audio/Self Esteem Fund.mp3")
		music = "Self Esteem Fund"
	GameSingleton.music = music
	get_node("Party/Player/MusicPlayer").play(GameSingleton.musicTime)
	Pla.cutscene = true
	get_node("Party/CLUI/ColorRect/AnimationPlayer").play("FadeFromBlack")
	
	#Play cutscene
	await get_node("Party/CLUI/ColorRect/AnimationPlayer").animation_finished
	var i = 0
	while i <= 8:
		Pla.move("move_down")
		await get_tree().create_timer(.25).timeout
		i+=1
	i = 0
	while i <= 7:
		Pla.move("move_right")
		await get_tree().create_timer(.25).timeout
		i+=1
	Pla.face("right")
	await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "The Exit! We made it!")
	Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "")
	$Mic.play()
	await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "AAAA")
	if $Mic.is_playing():
		await $Mic.finished
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Testing... Testing Hello?")
	await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Uh, yea hi...")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Good work, it looks like you have completed this section.")
	await Pla.Diologue(GameSingleton.CharList[2], "Neutral", "You could say that.")
	await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Can we leave now?")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Oh yea, sure... Lemme Just-")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "[font_size=15]What's that?    We dont let them go?[/font_size]")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Actually, Scratch that. Sorry we cant let you...")
	$Exit.get_node("AnimationPlayer").play("Dis")
	await $Exit.get_node("AnimationPlayer").animation_finished
	await Pla.Diologue(GameSingleton.CharList[1], "Angry", "WHAT THE HECK?!?!")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Yea, we need to make sure None of you have P.I. so...")
	$AnimationPlayer.play("Fall")
	$Party.Scare()
	await get_tree().create_timer(.25).timeout
	$Party.Scare()
	await get_tree().create_timer(.25).timeout
	$Party.Scare()
	await get_tree().create_timer(.25).timeout
	$Party.Scare()
	await $AnimationPlayer.animation_finished
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "They'll be fine...")
	await Pla.NPCDiologue("res://Textures/SpeakerIcon.png", "Probably...")
	await Pla.EndDiologue()
	get_tree().change_scene_to_file("res://Scenes/Menus/FinalMenu.tscn")
