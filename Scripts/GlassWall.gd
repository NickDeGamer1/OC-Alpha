extends Area2D

#Glass wall that Faelyn can break

@export_range(1,5) var level = 1
var stopS:bool
var pl
var breaking = false
var active = false

func Break(input):#Frequency to break
	stopS = false
	if (input == level - 1) or (input == level + 1):
		$AnimationPlayer.play("shake")
	elif (input == level):
		smash()
	else:
		$AnimationPlayer.play("RESET")

func stop():#Stops 
	stopS = true
	$AnimationPlayer.play("RESET")

func smash():#Breaks the glass
	breaking = true
	$AnimationPlayer.play("shake")
	$AnimationPlayer.speed_scale = 2
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.speed_scale = 1
	$AnimationPlayer.play("Shatter")
	await $AnimationPlayer.animation_finished
	active = true
	$"../Party/Player/EncloseSPR/AnimatedSprite2D/SingRadius".RemoveObj()

func exit():#I forgot what this does
	if !breaking:
		$AnimationPlayer.play("RESET")


func setup(v : bool):
	if v:
		smash()
