extends CharacterBody2D

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

func setup(num):
	NumerInList = num

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

func face(dir):
	spr.play("move_" + dir)
	spr.stop()
	spr.face("move_" + dir)

func move():
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).move()
	moveN(CheckPos())

func moveN(dir):
	var tween = create_tween()
	spr.play(dir)
	tween.tween_property(self, "position",position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
	moving = true
	await tween.finished
	stopAnim()
	moving = false

func stopAnim():
	await get_tree().create_timer(0.1).timeout
	if(!moving):
		spr.stop()
		spr.face("move_" + direction)

func CheckPos():
	var check
	if(NumerInList == 1):
		check = "Player"
	else:
		check = "PartyMember" + str(NumerInList-1)
	return CheckPosN(check)

func ResetPos():
	position.x = position.x - (int(position.x) % tile_size)
	position.y = position.y - (int(position.y) % tile_size)

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

func swap():
	loadSprite(GameSingleton.CharList[NumerInList])
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).swap()

func settemppos():
	temppos = position
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).settemppos()

func returntemppos():
	position = temppos
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).returntemppos()

func cut(inp):
	cutscene = inp
	if(get_node_or_null("../PartyMember" + str(NumerInList+1)) != null):
		get_node("../PartyMember" + str(NumerInList+1)).cut(inp)
