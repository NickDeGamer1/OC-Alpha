extends Area2D

var OnFire:bool = false
@export var Dio:bool = true
@onready var Pla = get_node("../Party/Player")
@export var num: int = 0
var broken: bool = false

func Break():
	if !broken:
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$CPUParticles2D.emitting = true
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(.2).timeout
		$CPUParticles2D.emitting = false
		broken = true


func interact():
	if GameSingleton.CharList[0] == "Shibe" and !OnFire:
		Pla.get_node("EncloseSPR/AnimatedSprite2D/AnimationPlayer2").play("Light_" + Pla.direction)
		await Pla.get_node("EncloseSPR/AnimatedSprite2D/AnimationPlayer2").animation_finished
		if Dio:
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.play("Fire")
			if (OptionsSingleton.Shadows == 0):
				$PointLight2D.visible = true
				$AnimationPlayer.play("light")
			$FireSound.play()
			await Pla.Diologue("Vex", "neutral", "Aww... I was gonna break those...")
			await Pla.Diologue("Shibe", "Neutral", "Arson :)")
			Pla.EndDiologue()
		SetFire()
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func SetFire():
	if !OnFire:
		OnFire = true
		$AnimatedSprite2D.visible = true
		$AnimatedSprite2D.play("Fire")
		if (OptionsSingleton.Shadows == 0):
			$PointLight2D.visible = true
			$AnimationPlayer.play("light")
		$FireSound.play()
		$Timer.start()
		await $Timer.timeout
		var i = 1
		while i < 5:
			get_node("RayCast2D" + str(i)).force_raycast_update()
			if get_node("RayCast2D" + str(i)).is_colliding():
				if get_node("RayCast2D" + str(i)).get_collider().name.contains("Wood"):
					get_node("RayCast2D" + str(i)).get_collider().SetFire()
			i+=1
		$Timer.start()
		await $Timer.timeout
		Burnt()

func Burnt():
	$Sprite2D.visible = false
	$AnimationPlayer.stop()
	$AnimatedSprite2D.visible = false
	if (OptionsSingleton.Shadows == 0):
		$AnimationPlayer.play("dim")
	$FireSound.stop()
	queue_free()
