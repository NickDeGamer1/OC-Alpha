extends Node

var Active:bool = false
var speed:int = 20

#Cursor controller for multiplayer

func _ready():
	await get_tree().create_timer(.1).timeout
	$Cursor.self_modulate = $"../../Party/Player/EncloseSPR/AnimatedSprite2D".Ccolor

func _input(event):
	if event.is_action_pressed("ToggleCursor"):#toggles cursor visibility as well as movement.
		if !Active:
			Active = true
			$Cursor.global_position = $"../../Party/Player".global_position
			$Cursor.visible = true
			$"../../Party/Player".cutscene = true
		else:
			Active = false
			$Cursor.visible = false
			$"../../Party/Player".cutscene = false
	elif event.is_action_pressed("ui_accept") and Active:#pings and announces to ping
		$"../Ping".Ping($Cursor.global_position)
	

func _physics_process(_delta):#moves cursor around based on input from controller
	if Active:
		if Input.is_action_pressed("face_down"):
			$Cursor.global_position.y = $Cursor.global_position.y + speed
		if Input.is_action_pressed("face_up"):
			$Cursor.global_position.y = $Cursor.global_position.y - speed
		if Input.is_action_pressed("face_left"):
			$Cursor.global_position.x = $Cursor.global_position.x - speed
		if Input.is_action_pressed("face_right"):
			$Cursor.global_position.x = $Cursor.global_position.x + speed
		
