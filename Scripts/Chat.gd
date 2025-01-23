extends Control

signal chatS
@export var PS: PackedScene
var Visibletime:float = 0
var inFocus:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !MpManager.Multip:
		visible = false
	else:
		$AnimationPlayer.play("MakeInvisible")

func _physics_process(delta):
	if visible and !inFocus:
		Visibletime+=delta
		
		if Visibletime > 5:
			if $MarginContainer/VBoxContainer/LineEdit.visible:
				$AnimationPlayer.play("MakeInvisible")
			else:
				$AnimationPlayer.play("MakeInvisibleWithoutDio")
			Visibletime = 0
	else:
		Visibletime = 0

func _input(event):
	if event.is_action_pressed("chat") and !inFocus and MpManager.Multip:
		get_node("../../Player").cutscene = true
		if $MarginContainer/VBoxContainer/LineEdit.visible:
			$AnimationPlayer.play("MakeVisible")
		else:
			$MarginContainer/VBoxContainer/LineEdit.visible = true
		inFocus = true
		await chatS
		$MarginContainer/VBoxContainer/LineEdit.grab_focus()
	elif event.is_action_released("chat"):
		chatS.emit()

func AddText(text, id):
	if !visible:
		$AnimationPlayer.play("MakeVisibleWithoutDio")
	var NewChat = PS.instantiate()
	NewChat.text = MpManager.Players[id].name + " [img=35]res://Textures/" + MpManager.Players[id].CC + "Icon.png[/img] " + ": " + text
	$MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer.add_child(NewChat)

func _on_line_edit_text_submitted(new_text):
	get_node("../../../MultiplayerManager").SendText(new_text, multiplayer.get_unique_id())
	$MarginContainer/VBoxContainer/LineEdit.text = ""
	$MarginContainer/VBoxContainer/LineEdit.release_focus()
	get_node("../../Player").cutscene = false

func _on_line_edit_focus_entered():
	get_node("../../Player").cutscene = true
	inFocus = true


func _on_line_edit_focus_exited():
	get_node("../../Player").cutscene = false
	inFocus = false
