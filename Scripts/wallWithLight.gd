extends Area2D
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	if (OptionsSingleton.Shadows != 0):
		$PointLight2D.visible = false
		$PointLight2D2.visible = false
	else:
		ResetTimer()


func _on_light_sound_area_area_entered(area: Area2D) -> void:
	if area.name == "PlayerCollider" and OptionsSingleton.Shadows == 0:
		$AnimationPlayer.play("Enter")

func _on_light_sound_area_area_exited(area: Area2D) -> void:
	if area.name == "PlayerCollider" and OptionsSingleton.Shadows == 0:
		$AnimationPlayer.play("Exit")

func _on_timer_timeout() -> void:
	$AnimationPlayer2.play("Flicker")

func ResetTimer() ->void:
	$Timer.wait_time = rng.randi_range(3,30)
	$Timer.start()
