extends Area2D

@export var initCount:int = 5
var count: int
var active: bool = false
var complete: bool = false
var ID:int

# Called when the node enters the scene tree for the first time.
func _ready():
	count = initCount
	$Label.text = str(count)

func interact():
	if GameSingleton.CharList[0] == "Mike":
		if !complete:
			if !active:
				active = true
				$Line2D.add_point(get_node("../Party/Player").global_position - global_position)
				get_node("../Party/Player").swappable = false
				$AudioStreamPlayer2D.play()
				count-=1
				$Label.text = str(count)
		else:
			complete = false
			while $Line2D.get_point_count() != 1:
				$Line2D.remove_point($Line2D.get_point_count() - 1)
				$AudioStreamPlayer2D.play()
				await get_tree().create_timer(.1).timeout
			get_node("../Port").resetwire()
			count = initCount
			$Label.text = str(count)
			get_node("../Party/Player").swappable = true
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, id):
	if Chr == "Mike":
		print(true)
		active = true
		var MikeInQuestion
		var OtherP = get_tree().get_nodes_in_group("OtherP")
		for q in OtherP:
			if id == q.ID:
				MikeInQuestion = q
				break
		$Line2D.add_point(MikeInQuestion.global_position - global_position)

func _on_party_moved():
	if active:
		if count > 0:
			count-=1
			$Line2D.add_point(get_node("../Party/Player").global_position - global_position)
			$Label.text = str(count)
			$AudioStreamPlayer2D.play()
		else:
			get_node("../Party/Player").cutscene = true
			while $Line2D.get_point_count() != 1:
				$Line2D.remove_point($Line2D.get_point_count() - 1)
				$AudioStreamPlayer2D.play()
				await get_tree().create_timer(.1).timeout
			count = initCount
			$Label.text = str(count)
			active = false
			get_node("../Party/Player").cutscene = false
			get_node("../Party/Player").swappable = true

func _on_multiplayer_manager_player_moved(_ID, Pos):
	if active and MpManager.multiplayer:
		if count > 0:
			count-=1
			$Line2D.add_point(Pos - global_position)
			$Label.text = str(count)
			$AudioStreamPlayer2D.play()
		else:
			while $Line2D.get_point_count() != 1:
				$Line2D.remove_point($Line2D.get_point_count() - 1)
				$AudioStreamPlayer2D.play()
				await get_tree().create_timer(.1).timeout
			count = initCount
			$Label.text = str(count)
			active = false
			get_node("../Party/Player").cutscene = false
			get_node("../Party/Player").swappable = true
