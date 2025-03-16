extends Area2D

#Pathweay Shibe can sniff out

func sniffOut():#Displays for a short while
	visible = true
	if !name.contains("end"):
		await get_tree().create_timer(1.5).timeout
		$AnimationPlayer.play("dissapear")
