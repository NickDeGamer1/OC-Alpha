extends Area2D

var Spinning: bool = false
@export var ToggleBlock:Node

signal Start
signal End


func _on_area_entered(area):
	if area.name == "GustOfWind":
		Spinning = true
		Start.emit()
		$AnimatedSprite2D.speed_scale = 3
		$AnimatedSprite2D.play("Spin")
		$AudioStreamPlayer2D.play()
		if ToggleBlock != null:
			ToggleBlock.call_deferred("toggleBlock", false)
		await get_tree().create_timer(1).timeout
		$AnimatedSprite2D.speed_scale = 1
		$AnimatedSprite2D.play("Spin")
		await get_tree().create_timer(1).timeout
		Spinning = false
		End.emit()
		$AnimatedSprite2D.play("RESET")

func _on_animated_sprite_2d_frame_changed():
	$LightOccluder2D.occluder = load("res://Prefabs/Occluders/SpinThingy" + str($AnimatedSprite2D.frame) + ".tres")
