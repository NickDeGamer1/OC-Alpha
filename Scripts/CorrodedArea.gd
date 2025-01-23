extends Area2D

var corroded:bool = true

func _ready():
	$AnimationPlayer.play("Idol")
	ResetSound()

func ResetSound():
	while corroded:
		var rng = RandomNumberGenerator.new()
		$TimerSound.wait_time = rng.randf_range(5,30)
		$TimerSound.start()
		await $TimerSound.timeout
		$AudioStreamPlayer2D.play()

func clean():
	if corroded:
		$AnimationPlayer.stop()
		$ColorRect.visible = false
		for i in get_children():
			if i.name.contains("Corrode"):
				i.get_node("AnimationPlayer").play("clean")
		$AudioStreamPlayer2D2.play()
		await get_node("Corrode3/AnimationPlayer").animation_finished
		$CollisionShape2D.disabled = true
		corroded = false
		$AnimationPlayer.play("appear")

func Reset():
	corroded = true
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("Idol")
	ResetSound()
