extends Area2D

var corroded:bool = true
#Corroded area for Damian's ability

func _ready():
	$AnimationPlayer.play("Idol")
	ResetSound()

func ResetSound():
	while corroded:#Plays sound anywhere between 5 and 30 sec
		var rng = RandomNumberGenerator.new()
		$TimerSound.wait_time = rng.randf_range(5,30)
		$TimerSound.start()
		await $TimerSound.timeout
		$AudioStreamPlayer2D.play()

func clean():#cleans corrosion by disabling the collision and playing the cleaning animation
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

func Reset():#resets back to original state
	corroded = true
	$CollisionShape2D.disabled = false
	$AnimationPlayer.play("Idol")
	ResetSound()
