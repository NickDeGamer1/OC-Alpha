extends Node

@export var MP: PackedScene
@export var OWP: PackedScene
var t = 0
var l = false
var time:float = 0
@onready var PingDisp = get_node_or_null("../Party/CLUI/UI/MPList/ScrollContainer/VBoxContainer")
var privanim
var privframe
var ActiveBridges:Array

@warning_ignore("unused_signal")
signal PlayerMoved

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}


# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.peer_connected.connect(peer_connected)
	$"../Party/Player".loadSpriteC(MpManager.Players[multiplayer.get_unique_id()].CC)
	$"../Party".SetLabel(MpManager.MPName)
	MpManager.id = multiplayer.get_unique_id()
	for i in MpManager.Players:
		if MpManager.Players[i].id != multiplayer.get_unique_id():
			var CurrentP = MP.instantiate()
			CurrentP.loadSprite(MpManager.Players[i].CC)
			CurrentP.SetLabel(MpManager.Players[i].name)
			CurrentP.ID = MpManager.Players[i].id
			CurrentP.add_to_group("MPPeer")
			get_node("../").add_child.call_deferred(CurrentP)
			MpManager.Players[i].X = $"../SpawnpointL/0".global_position.x
			MpManager.Players[i].Y = $"../SpawnpointL/0".global_position.y
			CurrentP.global_position = $"../SpawnpointL/0".global_position
			var OWpingNode = OWP.instantiate()
			OWpingNode.Set_color(CurrentP.get_node("EncloseSPR/AnimatedSprite2D").Ccolor)
			OWpingNode.ID = MpManager.Players[i].id
			add_child.call_deferred(OWpingNode)

func _process(delta):
	if multiplayer.get_unique_id() == 1:
		time = time + delta
		if time > .5:
			Ping()
			time = 0
	
	if get_node("../Party/Player").moving:
		MpManager.Players[multiplayer.get_unique_id()].X = get_node("../Party/Player").position.x
		MpManager.Players[multiplayer.get_unique_id()].Y = get_node("../Party/Player").position.y
		updateOthers.rpc(multiplayer.get_unique_id(), get_node("../Party/Player").global_position.x, get_node("../Party/Player").global_position.y)
	
	if get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").frame != privframe or privanim != get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").animation:
		updateFrame.rpc(multiplayer.get_unique_id(),
			get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").animation,
				get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").frame,
					get_node("../Party/Player").direction)
		privanim = get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").animation
		privframe = get_node("../Party/Player/EncloseSPR/AnimatedSprite2D").frame
	
	
	
	var OtherP = get_tree().get_nodes_in_group("OtherP")
	for i in MpManager.Players:
		for q in OtherP:
			if MpManager.Players[i].id == q.ID:
				q.global_position.x = MpManager.Players[i].X
				q.global_position.y = MpManager.Players[i].Y
				q.get_node("EncloseSPR/AnimatedSprite2D").animation = MpManager.Players[i].Anim
				q.get_node("EncloseSPR/AnimatedSprite2D").frame = MpManager.Players[i].Frame
				q.direction = MpManager.Players[i].Dir

@rpc("any_peer")
func OWping(id, Inp):
	get_tree().call_group("PingSprG", "Appear", id, Inp)

func Ping():
	PingIN.rpc(Time.get_ticks_msec())

@rpc("any_peer")
func PingIN(timeIN):
	PingOut.rpc_id(1,multiplayer.get_unique_id(), timeIN)

@rpc("any_peer")
func PingOut(id, timeOut):
	timeOut = (Time.get_ticks_msec() - timeOut)/2
	PingSend.rpc(id, timeOut)

@rpc("any_peer", "call_local")
func PingSend(id, ping):
	for j in PingDisp.get_children():
		if j.ID == id:
			j.UpdatePing(ping)

@rpc("any_peer", "call_local", "unreliable")
func updateOthers(id, MPX, MPY):
	MpManager.Players[id].X = MPX
	MpManager.Players[id].Y = MPY


@rpc("any_peer", "call_local", "unreliable")
func updateFrame(id, An, F, Di):
	MpManager.Players[id].Anim = An
	MpManager.Players[id].Frame = F
	MpManager.Players[id].Dir = Di

func peer_connected(_id):
	pass

func KickPlayer(i):
	Kick.rpc_id(i, "Kicked by Host")
	await get_tree().create_timer(.5).timeout
	MpManager.peer.disconnect_peer(i, false)

@rpc("call_local")
func Kick(Reason:String):
	MpManager.Multip = false
	MpManager.peer = null
	MpManager.Players = {}
	MpManager.Kicked = true
	MpManager.KR = Reason
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")

func peer_disconnected(id):
	if id != 1:
		MpManager.Players.erase(id)
		MpManager.PlayerPing.erase(id)
		for p in get_tree().get_nodes_in_group("MPPeer"):
			if p.ID == id:
				p.queue_free()
				break
		for q in PingDisp.get_children():
			if q.ID == id:
				q.queue_free()
				break
	else:
		MpManager.peer = null
		MpManager.Players = {}
		MpManager.PlayerPing = {}
		get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")

func SendText(Text, MPID):
	UpdateText.rpc(Text, MPID)

@rpc("any_peer", "call_local")
func UpdateText(Text, MPID):
	get_node("../Party/CLUI/Chat").AddText(Text, MPID)

func _input(event):
	if event.is_action_pressed("ability") and !$"../Party/Player".cutscene and !$"../Party/Player".moving:
		AbilityPress.rpc(multiplayer.get_unique_id(), $"../Party/Player".direction, GameSingleton.CharList[0])
	
	if event.is_action_pressed("interact") and !$"../Party/Player".cutscene and !$"../Party/Player".moving:
		InteractPress.rpc(multiplayer.get_unique_id(), $"../Party/Player".direction, GameSingleton.CharList[0])
	
	if event.is_action_released("ability") and get_node_or_null("../Party/Player/EncloseSPR/AnimatedSprite2D/SingRadius") != null and !$"../Party/Player".cutscene and !$"../Party/Player".moving:
		if $"../Party/Player/EncloseSPR/AnimatedSprite2D/SingRadius".active:
			endSing.rpc(multiplayer.get_unique_id())
	
	if event.is_action_pressed("ability") and !$"../Party/Player".visible and GameSingleton.CharList[0] == "Mittens":
		exitBridge.rpc(multiplayer.get_unique_id())


@rpc("any_peer")
func AbilityPress(id, dir, Char):
	var OtherP = get_tree().get_nodes_in_group("OtherP")
	for q in OtherP:
		if id == q.ID:
			q.get_node("EncloseSPR/AnimatedSprite2D").Ability(Char, dir)

@rpc("any_peer")
func InteractPress(id, dir, Char):
	var OtherP = get_tree().get_nodes_in_group("OtherP")
	for q in OtherP:
		if id == q.ID:
			var ray = q.get_node("RayCast2D")
			ray.target_position = inputs["move_" + dir] * 96
			ray.force_raycast_update()
			if ray.is_colliding() and ray.get_collider().has_method("MPinteract"):
				ray.get_collider().MPinteract(Char, id)

func endSingL():
	endSing.rpc(MpManager.id)

@rpc("any_peer")
func endSing(id):
	if id != multiplayer.get_unique_id():
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if id == q.ID:
				q.get_node("EncloseSPR/AnimatedSprite2D/SingRadius").endSing()

func PitchUpL(oct):
	if GameSingleton.CharList.has("Faelyn"):
		pitchUp.rpc(MpManager.id, oct)

func PitchDownL(oct):
	if GameSingleton.CharList.has("Faelyn"):
		pitchDown.rpc(MpManager.id, oct)

@rpc("any_peer")
func pitchUp(id, oct):
	if id != multiplayer.get_unique_id():
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if id == q.ID and q.get_node_or_null("EncloseSPR/AnimatedSprite2D/SingRadius") != null:
				q.get_node("EncloseSPR/AnimatedSprite2D/SingRadius").updatePitch(oct)

@rpc("any_peer")
func pitchDown(id, oct):
	if id != multiplayer.get_unique_id():
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if id == q.ID and q.get_node_or_null("EncloseSPR/AnimatedSprite2D/SingRadius") != null:
				q.get_node("EncloseSPR/AnimatedSprite2D/SingRadius").updatePitch(oct)

@rpc("any_peer")
func exitBridge(id):
	for i in ActiveBridges:
		if i.MPID == id:
			i.MPreturn(id)
			ActiveBridges.erase(i)

@rpc("any_peer")
func ExitPC(PC):
	get_node("../" + PC + "/AnimationPlayer").play("TurnOff")

func forcePos(id, Pos):
	updateOthers.rpc(id, Pos.x, Pos.y)


func _on_party_moved():
	PMmoved.rpc(multiplayer.get_unique_id, get_node("../Party/Player").global_position)

@rpc("any_peer")
func PMmoved(ID, Pos):
	emit_signal("PlayerMoved", ID, Pos)
