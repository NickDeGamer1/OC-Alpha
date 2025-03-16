extends Area2D

#Mittens bridge

var rng = RandomNumberGenerator.new()
var blinknum: int = rng.randi_range(3,5)
var blinktime= 0
var MPID:int
var Solo:bool = false
var direction:String = "none"
@export var active:bool = false
@export var canBlink: bool = true

func _process(delta):#Blinks
	blinktime += delta
	if blinktime > blinknum and canBlink and active:
		blink()

func blink():#Mittens blinks
	if !Solo:
		$Face1.visible = false
		$Face2.visible = true
		await get_tree().create_timer(.1).timeout
		$Face1.visible = true
		$Face2.visible = false
		blinknum = rng.randi_range(3,5)
		blinktime = 0

func interact():#If mittens, have mittens walk to bridge and play animation, if solo make them be able to cross
	if GameSingleton.CharList[0] == "Mittens":
		if !active:
			active = true
			get_node("../Party/Player").cutscene = true
			get_node("../Party/Player").visible = false
			get_node("../Party/TempSprite").position = get_node("../Party/Player").position
			get_node("../Party/TempSprite").loadSprite("Mittens")
			get_node("../Party/TempSprite").visible = true
			await get_node("../Party/TempSprite").moveN("move_" + get_node("../Party/Player").direction)
			get_node("../Party/TempSprite").visible = false
			$AnimationPlayer.play("Appear")
			get_node("../Party/Player").tempV = false
			if GameSingleton.CharList.size() > 1:
				await get_node("../Party/Player").swap()
				get_node("../Party/PartyMember" + str(GameSingleton.CharList.size() - 1)).queue_free()
				GameSingleton.CharList.pop_back()
				get_node("../Party/Player").cutscene = true
				get_node("../Party/Player").tempV = true
				$FullArea.disabled = true
				get_node("../Party/Player").cutscene = false
			else:
				get_node("../Party/Player/PlayerCollider/Playercollision").disabled = true
				var tween = create_tween()
				tween.tween_property(get_node("../Party/Player"), "global_position", $FaceArea.global_position,1).set_trans(Tween.TRANS_LINEAR)
				await tween.finished
				Solo = true
	elif active:
		var b:bool = true
		$FullArea.disabled = false
		for entity in get_overlapping_areas():
			if entity.name.contains("Player") or entity.name.contains("PM"):
				b = false
		if b:
			active = false
			get_node("../Party/Player").cutscene = true
			var child_node = load("res://Prefabs/PartyMember.tscn").instantiate()
			get_node("../Party").add_child(child_node)
			child_node.visible = false
			var PB = get_node("../Party/PartyMember" + str(GameSingleton.CharList.size() - 1))
			
			PB.get_node("RayCast2D").force_raycast_update()
			if !PB.get_node("RayCast2D").is_colliding():
				child_node.position = Vector2(PB.position.x - 96, PB.position.y)
			else:
				child_node.position = Vector2(PB.position.x, PB.position.y - 96)
			child_node.setup(GameSingleton.CharList.size())
			child_node.name = "PartyMember" + str(GameSingleton.CharList.size())
			child_node.loadSprite("Mittens")
			child_node.spr.updateshadow("Mittens")
			child_node.add_to_group("Character")
			GameSingleton.CharList.append("Mittens")
			await get_node("../Party/Player").revSwap()
			child_node.visible = true
			get_node("../Party/Player").visible = false
			get_node("../Party/TempSprite").loadSprite("Mittens")
			
			if get_node("../Party/Player").direction == "right":
				get_node("../Party/TempSprite").position = Vector2(get_node("../Party/Player").position.x + 96, get_node("../Party/Player").position.y)
			if get_node("../Party/Player").direction == "left":
				get_node("../Party/TempSprite").position = Vector2(get_node("../Party/Player").position.x - 96, get_node("../Party/Player").position.y)
				
			get_node("../Party/TempSprite").visible = true
			$AnimationPlayer.play_backwards("Appear")
			if get_node("../Party/Player").direction == "right":
				await get_node("../Party/TempSprite").moveN("move_left")
			if get_node("../Party/Player").direction == "left":
				await get_node("../Party/TempSprite").moveN("move_right")
			get_node("../Party/TempSprite").visible = false
			get_node("../Party/Player").visible = true
		else:
			$FullArea.disabled = true
			get_node("../Party/Player/AudioStreamPlayer2D").play()
	else:
		get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(_Char, ID):
	if !active:
		active = true
		get_node("../MultiplayerManager").ActiveBridges.append(self)
		$AnimationPlayer.play("Appear")
		$FullArea.disabled = true
		MPID = ID
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if ID == q.ID:
				q.visible = false
				q.get_node("CollisionShape2D").disabled = true

func MPreturn(ID):
	if active:
		$AnimationPlayer.play_backwards("Appear")
		$FullArea.disabled = false
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if ID == q.ID:
				q.visible = true
				q.get_node("CollisionShape2D").disabled = false
		active = false

func _on_face_area_area_entered(area):#Mittens blinks when players are on face
	if (area.name == "PlayerCollider") or (area.name == "PMCollider"):
		canBlink = false
		$Face1.visible = false
		$Face2.visible = true

func _on_face_area_area_exited(area):
	if (area.name == "PlayerCollider") or (area.name == "PMCollider"):
		canBlink = true
		$Face1.visible = true
		$Face2.visible = false

func _input(event):
	if Solo:#if solo, have player able to move to other side
		if event.is_action_pressed("move_left"):
			$Face1.visible = false
			$FaceL.visible = true
			direction = "left"
		elif event.is_action_released("move_left"):
			$Face1.visible = true
			$FaceL.visible = false
			direction = "none"
		elif event.is_action_pressed("move_right"):
			$Face1.visible = false
			$FaceR.visible = true
			direction = "right"
		elif event.is_action_released("move_right"):
			$Face1.visible = true
			$FaceR.visible = false
			direction = "none"
		if event.is_action_pressed("ability"):
			match direction:
				"right":
					var tween = create_tween()
					tween.tween_property(get_node("../Party/Player"), "global_position", $SpawnPointR.global_position,1).set_trans(Tween.TRANS_LINEAR)
					await tween.finished
					get_node("../Party/Player").ResetPos()
					$AnimationPlayer.play_backwards("Appear")
					await $AnimationPlayer.animation_finished
					Solo = false
					$FaceR.visible = false
					active = false
					get_node("../Party/Player").visible = true
					await get_node("../Party/Player").moveN("move_right")
					get_node("../Party/Player").cutscene = false
				"left":
					var tween = create_tween()
					tween.tween_property(get_node("../Party/Player"), "global_position", $SpawnPointL.global_position,1).set_trans(Tween.TRANS_LINEAR)
					await tween.finished
					get_node("../Party/Player").ResetPos()
					$AnimationPlayer.play_backwards("Appear")
					await $AnimationPlayer.animation_finished
					Solo = false
					$FaceL.visible = false
					active = false
					get_node("../Party/Player").visible = true
					await get_node("../Party/Player").moveN("move_left")
					get_node("../Party/Player").cutscene = false
