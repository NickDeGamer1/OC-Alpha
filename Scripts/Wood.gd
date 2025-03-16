extends Area2D

#Wood that Shibe can burn

var OnFire:bool = false
@export var Turned:bool = false
@export var Dio:bool = true
@onready var Pla = get_node("../Party/Player")

func _ready():#Changes sprite to be turned
	if Turned:
		$Sprite2D.rotation = PI/2
	if OptionsSingleton.Shadows != 0:
		$PointLight2D.visible = false
		$PointLight2D2.visible = false
		$AnimatedSprite2D.material = null

func interact():#if Shibe, Set fire to wood
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
			await Pla.Diologue(GameSingleton.CharList[1], "Worried", "[shake rate=30.0 level=5 connected=1]WHY DID YOU DO THAT?!?[/shake]")
			await Pla.Diologue("Shibe", "Neutral", "Arson :)")
			Pla.EndDiologue()
		SetFire()
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, ID):
	if Chr == "Shibe" and !OnFire:
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if ID == q.ID:
				q.get_node("EncloseSPR/AnimatedSprite2D/AnimationPlayer2").play("Light_" + Pla.direction)
				await q.get_node("EncloseSPR/AnimatedSprite2D/AnimationPlayer2").animation_finished
				break
		SetFire()
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func SetFire():#Set fire, burn adjacent, Burn out
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

func Burnt():#stop anim, dim, disable collision, 
	$Sprite2D.visible = false
	$AnimationPlayer.stop()
	$AnimatedSprite2D.visible = false
	$Sprite2D2.visible = true
	if (OptionsSingleton.Shadows == 0):
		$AnimationPlayer.play("dim")
	$FireSound.stop()
	$CollisionShape2D.disabled = true
