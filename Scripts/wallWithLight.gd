extends Area2D
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():#Disables flicker if not high graphics
	if (OptionsSingleton.Shadows != 0):
		$PointLight2D.visible = false
		$PointLight2D2.visible = false
	else:
		ResetTimer()


func _on_light_sound_area_area_entered(area: Area2D) -> void:#PLays audio when near
	if area.name == "PlayerCollider" and OptionsSingleton.Shadows == 0:
		$AnimationPlayer.play("Enter")

func _on_light_sound_area_area_exited(area: Area2D) -> void:#Stop audio when not near
	if area.name == "PlayerCollider" and OptionsSingleton.Shadows == 0:
		$AnimationPlayer.play("Exit")

func _on_timer_timeout() -> void:#Flicker
	$AnimationPlayer2.play("Flicker")

func ResetTimer() ->void:#Resets flicker
	$Timer.wait_time = rng.randi_range(3,30)
	$Timer.start()
