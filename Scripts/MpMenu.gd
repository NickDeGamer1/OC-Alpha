extends Control

@warning_ignore("unused_signal")
signal ErrOkSig

func _ready():
	GameSingleton.CharList.clear()
	MpManager.Multip = true
	$CenterContainer/MPType.visible = true
	$CenterContainer/MPType/MarginContainer/HBoxContainer/Online.grab_focus()
	$CenterContainer/OnlMP.visible = false
	$CenterContainer/NameInput.visible = false
	$CenterContainer/PlayersList.visible = false
	$CenterContainer/IPInput.visible = false
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func _on_online_pressed():
	$CenterContainer/MPType.visible = false
	$CenterContainer/NameInput.visible = true
	$CenterContainer/NameInput/VBoxContainer/Nameinput.grab_focus()

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")

func _on_host_button_pressed():
	MpManager.MPhost = true
	$CenterContainer/OnlMP.visible = false
	$CenterContainer/PlayersList.visible = true
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/SelfDisplay.IsServer(true)
	get_tree().call_group("PDisplay", "setKick")
	MpManager.peer = ENetMultiplayerPeer.new()
	var error = MpManager.peer.create_server(MpManager.port, 32)
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/CenterContainer.visible = false
	if error != OK:
		MpManager.Kicked = true
		MpManager.KR = "Cannot host"
		get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
	MpManager.peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	
	multiplayer.set_multiplayer_peer(MpManager.peer)
	SendPlayerInfo(MpManager.MPName, multiplayer.get_unique_id(), "Alex")

func _on_join_button_pressed():
	$CenterContainer/OnlMP.visible = false
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/SelfDisplay.IsServer(false)
	$CenterContainer/IPInput.visible = true
	$CenterContainer/IPInput/VBoxContainer/GetIP.grab_focus()
	

func _on_nameinput_text_submitted(new_text):
	MpManager.MPName = new_text
	$CenterContainer/NameInput.visible = false
	$CenterContainer/OnlMP.visible = true
	$CenterContainer/OnlMP/MarginContainer/HBoxContainer/JoinButton.grab_focus()
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/SelfDisplay.makeLabel()

#server and clients
func peer_connected(_id):
	pass

func peer_disconnected(id):
	MpManager.Players.erase(id)
	for h in get_tree().get_nodes_in_group("PDisplay"):
		if h.i == id:
			h.reset()
			break

#only on clients
func connected_to_server():
	SendPlayerInfo.rpc_id(1, MpManager.MPName, multiplayer.get_unique_id(), "Alex")
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/CenterContainer.visible = false

func connection_failed():
	MpManager.Kicked = true
	MpManager.KR = "Connection Failed"
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")

@rpc("any_peer")
func SendPlayerInfo(nameI, id, CC):
	if !MpManager.Players.has(id):
		MpManager.Players[id] = {
			"name": nameI,
			"id" : id,
			"CC" : CC,
			"X" : 0,
			"Y" : 0,
			"Anim" : "move_down",
			"Frame" : 0,
			"Dir" : "down",
			"timeSent" : 0.0
		}
	if !MpManager.PlayerPing.has(id):
		MpManager.PlayerPing[id] = {
			"id" : id,
			"Ping" : 0
		}
	if multiplayer.is_server():
		for i in MpManager.Players:
			SendPlayerInfo.rpc(MpManager.Players[i].name, i, MpManager.Players[i].CC)
	FillName.rpc(id)

@rpc("any_peer", "call_local")
func FillName(i):
	for q in $CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer.get_children():
		if q.i == i:
			break
		if q.name.contains("PlayerDisplay") and q.i == 0:
			if i != multiplayer.get_unique_id():
				q.setLabel(MpManager.Players[i].name)
				q.setChar(MpManager.Players[i].CC)
				q.i = i
				if i == 1:
					q.get_node("HBoxContainer/CenterContainer").visible = true
				else:
					q.get_node("HBoxContainer/CenterContainer").visible = false
				q.visible = true
				break

@rpc("any_peer",  "call_local")
func UpdateOthers(Pname, inpN):
	for i in $CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer.get_children():
		if i.name != "SelfDisplay" and i.Name == Pname:
			for q in MpManager.Players:
				if MpManager.Players[q].name == Pname:
					MpManager.Players[q].CC = inpN
			i.setChar(inpN)
	

@rpc("any_peer", "call_local")
func start_game():
	GameSingleton.CharList.push_back($CenterContainer/PlayersList/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer/SelfDisplay.CName)
	get_tree().change_scene_to_file("res://Scenes/Levels/Mptest1.tscn")

func _on_start_button_pressed():
	start_game.rpc()

func _on_get_ip_text_submitted(new_text):
	MpManager.ip = new_text
	$CenterContainer/IPInput.visible = false
	$CenterContainer/PlayersList.visible = true
	$CenterContainer/PlayersList/VBoxContainer/MarginContainer/CenterContainer/Conlabel.visible = true
	$CenterContainer/PlayersList/MarginContainer/StartButton.disabled = true
	MpManager.peer = ENetMultiplayerPeer.new()
	MpManager.peer.create_client(MpManager.ip, MpManager.port)
	MpManager.peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(MpManager.peer)

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

func _input(event):
	if event.is_action_pressed("interact") and event.is_action_pressed("ControllerInput") and$CenterContainer/PlayersList.visible == true and !$CenterContainer/PlayersList/MarginContainer/StartButton.disabled:
		start_game.rpc()
