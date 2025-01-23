extends Node2D

@onready var Pla = $Party/Player
var Save_path = "user://"
var fileName = "OCWorldSave.tres"


# Called when the node enters the scene tree for the first time.
func _ready():
	if OptionsSingleton.lastScene.contains("test2"):
		get_node("Party/Player").cutscene = true
		get_node("Party").position = get_node("Area2D").position
	OptionsSingleton.lastScene = "res://Scenes/Levels/test1.tscn"
	
	GameSingleton.Location = "Test1"
	var music: String
	
	if OptionsSingleton.Hypercam2:
		get_node("Party/Player/MusicPlayer").stream = load("res://Audio/Trinity (Remastered).wav")
		$Party/CLUI/Hypercam.visible = true
		music = "Trinity (Remastered)"
	else:
		get_node("Party/Player/MusicPlayer").stream = load("res://Audio/Self Esteem Fund.mp3")
		music = "Self Esteem Fund"
	GameSingleton.music = music
	get_node("Party/Player/MusicPlayer").play()
	
	unused()
	if get_node("Party/Player").cutscene:
		await get_node("Party/Player").move("move_up")
		await get_tree().create_timer(.5).timeout
		get_node("Party/Player").cutscene = false

func unused():
	var rng = RandomNumberGenerator.new()
	var rand = rng.randi_range(1,1000)
	if rand == 420:
		var x = rng.randi_range(-10,10)
		var y = rng.randi_range(-10,10)
		x = 48 + (x * 96)
		y = 48 + (y * 96)
		var scene = load("res://Prefabs/Unused.tscn")
		var child_node = scene.instantiate()
		child_node.position = Vector2(x,y)
		add_child(child_node)
