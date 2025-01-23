extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	match OptionsSingleton.zoom:
		1:
			scale = Vector2(.5, .5)
		2:
			scale = Vector2(.665, .665)
		3:
			scale = Vector2(1, 1)
		4:
			scale = Vector2(1.333, 1.333)
		5:
			scale = Vector2(2,2)
	$PingSpr.ID = multiplayer.get_unique_id()
	await get_tree().create_timer(.1).timeout
	print($"../../Party/Player/EncloseSPR/AnimatedSprite2D".Ccolor)
	$PingSpr.Set_color($"../../Party/Player/EncloseSPR/AnimatedSprite2D".Ccolor)

func _input(event):
	if event.is_action_pressed("ping") and !$PingSpr.visible:
		$PingSpr.position = get_global_mouse_position()
		get_parent().OWping.rpc(multiplayer.get_unique_id(), $PingSpr.position)
		$PingSpr/AnimationPlayer.play("appear")

func Ping(pos):
	if !$PingSpr.visible:
		$PingSpr.position = pos
		get_parent().OWping.rpc(multiplayer.get_unique_id(), $PingSpr.position)
		$PingSpr/AnimationPlayer.play("appear")
