extends Control

#Mike's minigame UI

signal complete
var open:bool = false
var x: int
var y: int
@export var Speed: float = 5

func start():#Starts and ends the minigame
	visible = true
	$AnimationPlayer.play("Start")
	await $AnimationPlayer.animation_finished
	open = true
	await complete
	open = false
	x = 0
	y = 0
	var rng = RandomNumberGenerator.new()
	var rand = rng.randi_range(1,1000)
	if rand == 800:
		$AnimationPlayer.play("Jumpscare")
		await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("end")
	await $AnimationPlayer.animation_finished
	

func _physics_process(_delta):#Moves around character
	if open:
		get_tree().call_group("RCs", "force_raycast_update")
		if Input.is_action_pressed("move_up"):
			if !$NinePatchRect/CenterContainer/Node2D/AsciiDude/RCUp.is_colliding():
				$NinePatchRect/CenterContainer/Node2D/AsciiDude.position.y -= Speed
		elif Input.is_action_pressed("move_down"):
			if !$NinePatchRect/CenterContainer/Node2D/AsciiDude/RCDown.is_colliding():
				$NinePatchRect/CenterContainer/Node2D/AsciiDude.position.y += Speed
		if Input.is_action_pressed("move_left"):
			if !$NinePatchRect/CenterContainer/Node2D/AsciiDude/RCLeft.is_colliding():
				$NinePatchRect/CenterContainer/Node2D/AsciiDude.position.x -= Speed
		elif Input.is_action_pressed("move_right"):
			if !$NinePatchRect/CenterContainer/Node2D/AsciiDude/RCRight.is_colliding():
				$NinePatchRect/CenterContainer/Node2D/AsciiDude.position.x += Speed

func _on_finish_area_body_entered(body):#Ends minigame
	if body.name == "AsciiDude":
		complete.emit()

func _on_death_area_body_entered(body):#restarts minigame
	if body.name == "AsciiDude":
		$NinePatchRect/CenterContainer/Node2D/AsciiDude.position = Vector2(64,83)
