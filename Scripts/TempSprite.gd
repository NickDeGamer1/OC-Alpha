extends CharacterBody2D

#TempSprite used when swapping characters

var moving = false
var cutscene = false
var tile_size = 96
var animation_speed = 4
var direction = "down"
var scene
@onready var ray = $RayCast2D

var spr
var occ

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func ResetAnim():
	$AnimationPlayer.play("RESET")

func ResetPos():
	position.x = position.x - (int(position.x) % tile_size)
	position.y = position.y - (int(position.y) % tile_size)


func loadSprite(Charname):#Loads character
	if $EncloseSPR.has_node("AnimatedSprite2D"):
		$EncloseSPR.remove_child($EncloseSPR.get_node("AnimatedSprite2D"))
	var loc = "res://Prefabs/Characters/" + Charname + "/" + Charname + "Anim.tscn"
	scene = load(loc)
	var child_node = scene.instantiate()
	$EncloseSPR.add_child(child_node)
	spr = $EncloseSPR/AnimatedSprite2D
	occ = $EncloseSPR/AnimatedSprite2D/LightOccluder2D
	spr.updateshadow(Charname)
	face(direction)

func face(dir):#Look in direction
	direction = dir
	spr.play("move_" + dir)
	spr.stop()
	spr.face("move_" + dir)

func moveN(dir):#Move in direction
	var tween = create_tween()
	spr.play(dir)
	tween.tween_property(self, "position",position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	moving = true
	await tween.finished
	stopAnim()
	moving = false

func stopAnim():#Stop the animation
	await get_tree().create_timer(0.1).timeout
	if(!moving):
		spr.stop()
		spr.face("move_" + direction)

func CheckPos(NumerInList):
	var check = "../PartyMember" + str(NumerInList)
	CheckPosN(check)

func CheckPosN(inp):#check the position of the next character
	var check = get_node(inp)
	if (global_position.x == check.global_position.x):
		if(global_position.y > check.global_position.y):
			direction = "up"
			return "move_up"
		else:
			direction = "down"
			return "move_down"
	else:
		if(global_position.x > check.global_position.x):
			direction = "left"
			return "move_left"
		else:
			direction = "right"
			return "move_right"

func checkFreeze():#Check if the tile is freezable
	ray.target_position = inputs["move_" + direction] * tile_size
	ray.force_raycast_update()
	if ray.is_colliding() and ray.get_collider().has_method("Freeze"):
		$EncloseSPR/AnimatedSprite2D/AnimationPlayer.play("wind_"+ direction)
		await $EncloseSPR/AnimatedSprite2D/AnimationPlayer.animation_finished
		ray.get_collider().Freeze()

func freeze():#Freeze the tile
	await checkFreeze()
	if !ray.is_colliding() or !ray.get_collider().has_method("Freeze"):
		await get_tree().create_timer(.5).timeout
		match direction:#freezes adjacent tiles
			"up":
				face("left")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("right")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("down")
				await get_tree().create_timer(.5).timeout
			"down":
				face("right")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("left")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("up")
				await get_tree().create_timer(.5).timeout
			"left":
				face("up")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("down")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("right")
				await get_tree().create_timer(.5).timeout
			"right":
				face("down")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("up")
				await checkFreeze()
				await get_tree().create_timer(.5).timeout
				face("left")
				await get_tree().create_timer(.5).timeout
	$AnimationPlayer.play("disappear")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	visible = false
