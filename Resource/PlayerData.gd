extends Resource
class_name PlayerData

@export var CharListS = []
@export var ParPos = []

func updatePos(inp : Vector2):
	ParPos.push_back(inp)

func clearPos():
	ParPos = []
