extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for q in GameSingleton.CharList:
		for i in children:
			if i.name.contains(q):
				i.Open()
	var arr = ["All"]
	var Items = get_tree().get_nodes_in_group("OverworldItem")
	for MarioBros in Items:
		if MarioBros.name.contains("Lever"):
			for Luigi in GameSingleton.CharList:
				if MarioBros.name.contains(Luigi):
					arr.push_back(MarioBros.Output)
	
	
	var Izzy = get_tree().get_nodes_in_group("Blocks")
	var love = [get_node("../YellowBlock")]#Blocks to keep
	for mylove in Izzy:
		for Schnuckems in arr:
			if mylove.name.contains(Schnuckems):
				love.push_back(mylove)
	
	for l in love:
		Izzy.erase(l)
	
	for heart in Izzy:
		heart.queue_free()
