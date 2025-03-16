extends CharacterBody2D

#Sprite displayed for multiplayer

var moving = false
var cutscene = false
var tile_size = 96
var animation_speed = 4
var direction = "down"
var scene
@export var ID : int
var spr
var occ

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func ResetAnim():
	$AnimationPlayer.play("RESET")

#Loads character
func loadSprite(Charname):
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

#Faces direction
func face(dir):
	direction = dir
	spr.play("move_" + dir)
	spr.stop()
	spr.face("move_" + dir)

#Moves direction
func moveN(dir):
	var tween = create_tween()
	spr.play(dir)
	tween.tween_property(self, "position",position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	moving = true
	await tween.finished
	stopAnim()
	moving = false

#Stops the animation playing
func stopAnim():
	await get_tree().create_timer(0.1).timeout
	if(!moving):
		spr.stop()
		spr.face("move_" + direction)

#Sets player label
func SetLabel(N: String):
	$Label.text = N
	$Label.visible = true

#Updates position, frame and animation
func Updated(Upos: Vector2, Anim: String, num: int):
	position = Upos
	spr.animation = Anim
	spr.frame = num

#Pings
func Ping(pos):
	$PingSpr.global_position = pos
	$PingSpr/AnimationPlayer.play("appear")
