extends Area2D

#Spool that mike uses

@export var initCount:int = 5
@export var wireColor:Color = Color.RED
var count: int
var active: bool = false
var complete: bool = false
var ID:int

# Called when the node enters the scene tree for the first time.
func _ready():#Changes label to count
	count = initCount
	$Label.text = str(count)
	$Label.add_theme_color_override("font_color", wireColor)#Sets color
	$Line2D.default_color = wireColor

func interact():
	if GameSingleton.CharList[0] == "Mike":#If mike, start drawing line, count down
		if !complete:
			if !active:
				active = true
				$Line2D.add_point(get_node("../Party/Player").global_position - global_position)
				get_node("../Party/Player").swappable = false
				$AudioStreamPlayer2D.play()
				count-=1
				$Label.text = str(count)
		else:#Resets wire
			complete = false
			get_node("../Port").resetwire()
			while $Line2D.get_point_count() != 1:
				$Line2D.remove_point($Line2D.get_point_count() - 1)
				$AudioStreamPlayer2D.play()
				await get_tree().create_timer(.1).timeout
			count = initCount
			$Label.text = str(count)
			get_node("../Party/Player").swappable = true
	else:
		if !get_node("../Party/Player/AudioStreamPlayer2D").playing:
			get_node("../Party/Player/AudioStreamPlayer2D").play()

func MPinteract(Chr, id):#Sets mike to use wire
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
	if active:#Adds new line to wire
		if count > 0:
			count-=1
			$Line2D.add_point(get_node("../Party/Player").global_position - global_position)
			$Label.text = str(count)
			$AudioStreamPlayer2D.play()
		else:#Resets wire
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
	if active and MpManager.multiplayer:#Same as party moved but only when Mike is moving
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
