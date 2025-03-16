extends Area2D

#Wires that Athena can cut

var Cut:bool = false

var timer1 = 0
var timer2 = 0
var time1:int = 4
var time2:int = 2
var rng = RandomNumberGenerator.new()

@export var dio:bool = false
@onready var Pla = get_node("../Party/Player")

func interact():#If athena, then cut wires and play sparking animations
	if GameSingleton.CharList[0] == "Athena":
		if dio:#Play dio if dio
			await Pla.Diologue("Athena", "Neutral", "These wires are in the way.")
			await Pla.Diologue("Athena", "Neutral", "I wonder if...")
		Pla.cutscene = true
		get_node("../Party/Player/EncloseSPR/AnimatedSprite2D/SwordPlayer").play("Swing_" + Pla.direction)
		await get_node("../Party/Player/EncloseSPR/AnimatedSprite2D/SwordPlayer").animation_finished
		$AnimatedSprite2D.play("Cut")
		Cut = true
		$CollisionShape2D.disabled = true
		$LightOccluder2D.visible = false
		if dio:
			await Pla.Diologue("Athena", "Neutral", "I'm sure those weren't Important.")
			Pla.EndDiologue()
		else:
			Pla.cutscene = false
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, ID):#Cut wires if MP
	if Chr == "Athena":
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if ID == q.ID:
				q.get_node("EncloseSPR/AnimatedSprite2D/SwordPlayer").play("Swing_" + Pla.direction)
				await q.get_node("EncloseSPR/AnimatedSprite2D/SwordPlayer").animation_finished
				break
		$AnimatedSprite2D.play("Cut")
		Cut = true
		$CollisionShape2D.disabled = true
		$LightOccluder2D.visible = false
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func _process(delta):#Sparks
	if Cut and (OptionsSingleton.Shadows == 0):
		timer1 += delta
		timer2 += delta
		
		if timer1 > time1:
			$AudioStreamPlayer2D.play()
			$CPUParticles2D.visible = true
			$CPUParticles2D.emitting = true
			endTim1()
		if timer2 > time2:
			$AudioStreamPlayer2D.play()
			$CPUParticles2D2.visible = true
			$CPUParticles2D2.emitting = true
			endTim2()


func endTim1():#Start timer 1
	await get_tree().create_timer(0.2).timeout
	$CPUParticles2D.visible = false
	timer1 = 0
	time1 = rng.randi_range(1,5)


func endTim2():#Start timer 2
	await get_tree().create_timer(0.5).timeout
	$CPUParticles2D2.visible = false
	timer2 = 0
	time2 = rng.randi_range(1,5)
