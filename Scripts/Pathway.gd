extends Area2D


func sniffOut():
	visible = true
	if !name.contains("end"):
		await get_tree().create_timer(1.5).timeout
		$AnimationPlayer.play("dissapear")
