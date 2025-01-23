extends Area2D

@export_range(1,5) var level = 1
var stopS:bool
var pl
var breaking = false
var active = false

func Break(input):
	stopS = false
	if (input == level - 1) or (input == level + 1):
		$AnimationPlayer.play("shake")
	elif (input == level):
		smash()
	else:
		$AnimationPlayer.play("RESET")

func stop():
	stopS = true
	$AnimationPlayer.play("RESET")

func smash():
	breaking = true
	$AnimationPlayer.play("shake")
	$AnimationPlayer.speed_scale = 2
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.speed_scale = 1
	$AnimationPlayer.play("Shatter")
	await $AnimationPlayer.animation_finished
	active = true
	$"../Party/Player/EncloseSPR/AnimatedSprite2D/SingRadius".RemoveObj()

func exit():
	if !breaking:
		$AnimationPlayer.play("RESET")


func setup(v : bool):
	if v:
		smash()
