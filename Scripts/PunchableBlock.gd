extends Area2D


func punched():
	$WallBits/AnimationPlayer.play("Break")
	await $WallBits/AnimationPlayer.animation_finished
