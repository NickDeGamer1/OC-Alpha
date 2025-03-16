extends Area2D

#Re-adds Mittens to party if players step on space

@onready var Spr = get_node("../../Party/TempSprite")

func _on_area_entered(area):#Stops party, sets mittens to walk to end of party and re add to party
	if (area.name == "PlayerCollider") and get_parent().active:
		await get_tree().create_timer(.5).timeout
		get_node("../../Party/Player").cutscene = true
		get_node("../AnimationPlayer").play_backwards("Appear")
		Spr.loadSprite("Mittens")
		Spr.global_position = get_node("../SpawnPointL").global_position
		var minLeft = get_node("../../Party/PartyMember" + str(GameSingleton.CharList.size() - 1)).global_position.x + 5
		Spr.visible = true
		while(Spr.global_position.x > minLeft):
			await Spr.moveN("move_left")
		
		minLeft = get_node("../../Party/PartyMember" + str(GameSingleton.CharList.size() - 1)).global_position.y - 100
		print(str(minLeft) + " " + str(Spr.global_position.y))
		while(Spr.global_position.y < minLeft):
			await Spr.moveN("move_down")
			print(str(minLeft) + " " + str(Spr.global_position.y))
		Spr.visible = false
		var child_node = load("res://Prefabs/PartyMember.tscn").instantiate()
		get_node("../../Party").add_child(child_node)
		child_node.visible = false
		var PB = get_node("../../Party/PartyMember" + str(GameSingleton.CharList.size() - 1))
		child_node.position = Vector2(PB.position.x, PB.position.y - 96)
		child_node.setup(GameSingleton.CharList.size())
		child_node.name = "PartyMember" + str(GameSingleton.CharList.size())
		child_node.loadSprite("Mittens")
		child_node.spr.updateshadow("Mittens")
		child_node.add_to_group("Character")
		GameSingleton.CharList.append("Mittens")
		child_node.visible = true
		get_parent().active = false
		get_parent().get_node("FullArea").disabled = false
		get_node("../../Party/Player").cutscene = false
