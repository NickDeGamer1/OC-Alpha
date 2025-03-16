extends Area2D

#Vents that Aurora can use

@onready var Pla = $"../Party/Player"
@onready var Temp = $"../Party/TempSprite"
var Vent1
@export var Enterence:bool = true
@export var ConnectedVent:int = 1
var Tpos

func _ready():#Connects vents
	Vent1 = get_node("../Vent" + str(ConnectedVent))

func interact():
	if Enterence:
		Entrence()
	else:
		Exit()

func MPinteract(Chr, ID):#Moves player in multiplayer
	if Chr == "Alex" or Chr == "Aurora":
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		var activeP
		for q in OtherP:
			if ID == q.ID:
				activeP = q
				break
		if Enterence:
			Temp.global_position = activeP.global_position
			Temp.loadSprite(Chr)
			Temp.visible = true
			activeP.loadSprite("Aurora")
		else:
			activeP.visible = false
			activeP.loadSprite("Alex")
			await get_tree().create_timer(1).timeout
			activeP.visible = true
			Temp.visible = false

func Entrence():#If Alex, Make Tempsprite Alex and move player to other side, make player Aurora
	if (GameSingleton.CharList[0] == "Alex"):
		Pla.cutscene = true
		var tween = create_tween()
		Pla.visible = false
		Temp.position = Pla.position
		Temp.loadSprite(GameSingleton.CharList[0])
		Temp.visible = true
		Tpos = Pla.position
		tween.tween_property(Pla, "global_position", Vent1.position, 1.0).set_trans(Tween.TRANS_LINEAR)
		$AudioStreamPlayer2D.play()
		await tween.finished
		Pla.solo = true
		GameSingleton.CharList[0] = "Aurora"
		Pla.loadSpriteC("Aurora")
		$"../DiscordManager".Update()
		$"../Vent2/AudioStreamPlayer2D".play()
		Pla.ResetPos()
		if get_node_or_null("../MultiplayerManager") != null:
			get_node_or_null("../MultiplayerManager").forcePos(MpManager.id, Vent1.global_position)
		Pla.visible = true
		Pla.cutscene = false
		
	else:
		$"../Party/Player/AudioStreamPlayer2D".play()

func Exit():#Send player back and return them to Alex
	Pla.cutscene = true
	var tween = create_tween()
	Pla.visible = false
	tween.tween_property(Pla, "global_position", get_node("../Party/TempSprite").global_position, 1.0).set_trans(Tween.TRANS_LINEAR)
	$AudioStreamPlayer2D.play()
	await tween.finished
	
	Pla.solo = false
	GameSingleton.CharList[0] = "Alex"
	Pla.loadSpriteC("Alex")
	Temp.visible = false
	$"../DiscordManager".Update()
	Pla.visible = true
	get_node("../Vent" + str(ConnectedVent) + "/AudioStreamPlayer2D").play()
	if get_node_or_null("../MultiplayerManager") != null:
			get_node_or_null("../MultiplayerManager").forcePos(MpManager.id, Temp.global_position)
	Pla.cutscene = false
