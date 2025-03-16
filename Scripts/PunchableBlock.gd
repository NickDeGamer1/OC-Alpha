extends Area2D

#Glen-4's wall breaking

func punched():
	$WallBits/AnimationPlayer.play("Break")
	await $WallBits/AnimationPlayer.animation_finished
