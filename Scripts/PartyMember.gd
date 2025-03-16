extends CharacterBody2D

#Party member, will fallow member ahead

var moving = false
var cutscene = false
var tile_size = 96
var animation_speed = 4
var direction = "down"
var scene
var NumerInList
var temppos

var spr
var occ

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

#Sets number in list
func setup(num):
	NumerInList = num

#Loads character
func loadSprite(Charname):
	if has_node("AnimatedSprite2D"):
		remove_child(self.get_node("AnimatedSprite2D"))
	var loc = "res://Prefabs/Characters/" + Charname + "/" + Charname + "Anim.tscn"
	scene = load(loc)
	var child_node = scene.instantiate()
	add_child(child_node)
	spr = $AnimatedSprite2D
	occ = $AnimatedSprite2D/LightOccluder2D
	spr.updateshadow(Charname)
	face(direction)

#Faces direction
func face(dir):
	spr.play("move_" + dir)
	spr.stop()
	spr.face("move_" + dir)

#Sends to next party member and moves
func move():
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).move()
	moveN(CheckPos())

#Moves in direction of party member ahead and animates
func moveN(dir):
	var tween = create_tween()
	spr.play(dir)
	tween.tween_property(self, "position",position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	moving = true
	await tween.finished
	stopAnim()
	moving = false

#Stops moving anim
func stopAnim():
	await get_tree().create_timer(0.1).timeout
	if(!moving):
		spr.stop()
		spr.face("move_" + direction)

#checks if player or party member, calls CheckPosN
func CheckPos():
	var check
	if(NumerInList == 1):
		check = "Player"
	else:
		check = "PartyMember" + str(NumerInList-1)
	return CheckPosN(check)

#Resets position to grid
func ResetPos():
	position.x = position.x - (int(position.x) % tile_size)
	position.y = position.y - (int(position.y) % tile_size)

#Sets movement direction based on where Current member needs to go
func CheckPosN(n):
	var check = get_node("../" + n)
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

#Sets current sprite and calls in next
func swap():
	loadSprite(GameSingleton.CharList[NumerInList])
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).swap()

#Sets temp pos to teleport back to
func settemppos():
	temppos = position
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).settemppos()

#Returns to temppos after moving
func returntemppos():
	position = temppos
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).returntemppos()

#Sets cutscene and sends to next
func cut(inp):
	cutscene = inp
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).cut(inp)
