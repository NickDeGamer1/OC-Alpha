extends Node2D

var spawnpos = 96
var time = 0
var pos
var rng = RandomNumberGenerator.new()
var oldnum
var arr = []
var discon = true
@export var SpawnUp:bool = false

signal Finished
@warning_ignore("unused_signal")
signal moved

@onready var Pla = $Player
var Save_path = "user://"
var fileName = "OCCharacterSave.tres"

# Called when the node enters the scene tree for the first time.
func _ready():
	var loc = "res://Prefabs/PartyMember.tscn"
	
	if !MpManager.Multip:
		for n in GameSingleton.CharList.size() - 1:
			var scene = load(loc)
			var child_node = scene.instantiate()
			add_child(child_node)
			if SpawnUp:
				child_node.position = Vector2(0, -spawnpos)
			else:
				child_node.position = Vector2(spawnpos , 0)
			child_node.name = "PartyMember" + str(n+1)
			child_node.setup(n+1)
			child_node.loadSprite(GameSingleton.CharList[n + 1])
			child_node.spr.updateshadow(GameSingleton.CharList[n + 1])
			spawnpos += 96
			child_node.add_to_group("Character")
	pos = Pla.position
	
	#DisplayCon()


func _process(delta):
	time += delta
	if(time > OptionsSingleton.BanterFreq):
		if pos == Pla.position and !Pla.cutscene and OptionsSingleton.Banter and !MpManager.Multip:
			Interactions()
		pos = Pla.position
		time = 0

func Interactions():
	calcdio()
	var Interact = arr.pick_random()
	#Interact = 20
	match Interact:
		1:
			await Pla.Diologue("Alex", "Neutral", "So, how's everyone's day?")#Alex, Vex, Athena, Faelyn
			await Pla.Diologue("Vex", "Neutral", "I'd say alright")
			await Pla.Diologue("Athena", "Neutral", "Could be better...")
			await Pla.Diologue("Faelyn", "Colon3", "Doing good! :3")
			await Pla.Diologue("Alex", "Worried", "How are you doing that?")
			await Pla.Diologue("Faelyn", "Colon3", "Doing what? :3")
			await Pla.Diologue("Alex", "Worried", "That")
			await Pla.Diologue("Faelyn", "Colon3", ">:3")
			await Pla.Diologue("Alex", "Scared", "[shake rate=30.0 level=5 connected=1]You are both confusing and scaring me right now.[/shake]")
		2:
			await Pla.Diologue("Vex", "Neutral", "You know what we should do?")#Vex, Faelyn, Alex, Mittens
			await Pla.Diologue("Vex", "Excited", "We should start a band")
			await Pla.Diologue("Faelyn", "Excited", "HECK YES!!")
			await Pla.Diologue("Vex", "Neutral", "We got me on guitar, Faelyn as lead, Alex, can you play anything?")
			await Pla.Diologue("Alex", "Neutral", "I can kinda play the Pokeflute...")
			await Pla.Diologue("Vex", "Neutral", "That works!")
			await Pla.Diologue("Mittens", "Neutral",  "I can play an instrument")
			await Pla.Diologue("Mittens", "Neutral", "an instrument of mass destruction that is.")
			await Pla.Diologue("Vex", "Neutral", "I like it!")
		3:
			await Pla.Diologue("Alex", "Neutral", "So we have")#Alex, Athena, Faelyn, Vex, Mittens
			await Pla.Diologue("Alex", "Neutral", "A Dragon|[img=50]res://Textures/AthenaIcon.png[/img]|")
			await Pla.Diologue("Alex", "Neutral", "A Fox|[img=50]res://Textures/FaelynIcon.png[/img]|")
			await Pla.Diologue("Alex", "Neutral", "A Wolf|[img=50]res://Textures/VexIcon.png[/img]|")
			await Pla.Diologue("Alex", "Neutral", "Am I the only")
			await Pla.Diologue("Alex", "Truth", "(semi)human")
			await Pla.Diologue("Alex", "Neutral", "here?")
			await Pla.DiologueE("Vex", "Neutral", "Wait wha-")
			await Pla.Diologue("Alex", "Neutral", "Don't worry about it...")
		4:
			await Pla.Diologue("Alex", "Neutral", "So like,")#Alex, Faelyn
			await Pla.Diologue("Alex", "Neutral", "Faelyn, you're from PaRappa Town right?")
			await Pla.Diologue("Faelyn", "Happy", "Right.")
			await Pla.Diologue("Alex", "Neutral", "And I'm from Hoenn")
			await Pla.Diologue("Alex", "Worried", "[shake rate=10.0 level=1 connected=1]Which means...[/shake]")
			await Pla.Diologue("Alex", "Scared", "[shake rate=30.0 level=5 connected=1]How are we talking to each other right now?[/shake]")
			await Pla.Diologue("Faelyn", "Worried", "Um... we're right next to each other?")
			await Pla.Diologue("Alex", "Annoyed", "No, I mean legally")
			await Pla.Diologue("Faelyn", "Neutral", "Oh.")
			await Pla.Diologue("Faelyn", "Colon3", "I have no idea.")
		5:
			await Pla.Diologue("Athena", "Neutral", "We need a plan to escape this place.")
			await Pla.Diologue("Athena", "Neutral", "Any ideas?")
			await Pla.Diologue("Vex", "Neutral", "I mean, I know a Demon that can teleport us...")
			await Pla.Diologue("Athena", "Neutral", "Well, are they here now?")
			await Pla.Diologue("Vex", "Neutral", "Uh, No... No he is not")
			await Pla.Diologue("Athena", "Neutral", "Any other ideas?")
			await Pla.NPCDiologue(null, "......")
			await Pla.Diologue("Athena", "Neutral", "Well, inbox is always open.")
		6:
			await Pla.Diologue("Mittens", "Neutral", "I got it!")
			await Pla.Diologue("Athena", "Neutral", "Got what?")
			await Pla.Diologue("Mittens", "Neutral", "If we complete these puzzles, maybe we can escape!")
			await Pla.Diologue("Alex", "Neutral", "We don't even know that for sure...")
			await Pla.Diologue("Alex", "Worried", "We could just be trapped here for eternity. Doing puzzles over and over again,")
			await Pla.Diologue("Alex", "Scared", "[shake rate=30.0 level=5 connected=1]As some sick punishment for something we did in the past.[/shake]")
			await Pla.Diologue("Mittens", "Neutral", "...")
			await Pla.Diologue("Athena", "Neutral", "...")
			await Pla.Diologue("Mittens", "Neutral", "Alex are you ok?")
			await Pla.Diologue("Alex", "Neutral", "No.")
		7:
			await Pla.Diologue("Vex", "Neutral", "Hey Alex?")
			await Pla.Diologue("Alex", "Neutral", "What's up?")
			await Pla.Diologue("Vex", "Neutral", "I don't know if this is too much to ask, but how did you meet Aurora?")
			await Pla.Diologue("Alex", "Neutral", "Long story, but basically I got captured by Team Aqua. Found Aurora in one of their smuggling boxes.")
			await Pla.Diologue("Alex", "Neutral", "We both escaped and she's been living in my freezer ever since.")
			await Pla.Diologue("Vex", "Neutral", "Oh cool! Not really a long story though.")
			await Pla.Diologue("Alex", "Neutral", "I- guess not.")
		8:
			await Pla.Diologue("Faelyn", "Neutral", "Come on guys!  Just a few more puzzles and we can escape here!")
			await Pla.Diologue("Faelyn", "Excited", "[wave amp=50.0 freq=5.0 connected=1][rainbow freq=1.0 sat=0.8 val=0.8]WE GOTTA BELIEVE![/rainbow][/wave]")
		9:
			await Pla.Diologue("Athena", "Neutral", "So, why are we stuck in this prison?")
			await Pla.Diologue("Vex", "Neutral", "This could just be a weird dream we are all having consecutively")
			await Pla.Diologue("Alex", "Worried", "My theory is too depressing apparently.")
			await Pla.Diologue("Mittens", "Neutral", "Maybe all we are is pictures and code in some computer")
			await Pla.Diologue("Athena", "Neutral", "Nah")
			await Pla.Diologue("Vex", "Neutral", "Seems Unlikely")
		10:
			await Pla.Diologue("Vex", "Neutral", "So, How about that weather?")
			await Pla.Diologue("Mittens", "Neutral", "We've.. been inside this building.")
			await Pla.Diologue("Vex", "Neutral", "Yea, crazy right?")
			await Pla.Diologue("Vex", "Neutral", "All this gray? Occasional blue?")
		11:
			await Pla.Diologue("Shibe", "Neutral", "I'm eyeing the green guy's shoes.")
			await Pla.Diologue("Alex", "Worried", "What do you want with my shoes?")
			await Pla.Diologue("Shibe", "Neutral", "They'd make the perfect chew toy.")
			await Pla.DiologueE("Alex", "Scared", "Oh, uh   ")
			await Pla.Diologue("Alex", "Neutral", "Yea, No")
		12:
			await Pla.Diologue("Mike", "Neutral", "Hey Glen-4?")
			await Pla.Diologue("Glen4", "Neutral", "Whats up?")
			await Pla.DiologueE("Mike", "Neutral", "char* ptr;   ")
			await Pla.Diologue("Mike", "Neutral", "for(ptr = (char*)0x00010000 ;; *(ptr++) = 0);")
			await Pla.Diologue("Glen4", "Scared", "Wait, what?")
			await Pla.Diologue("Mike", "Neutral", ":(){:l:&};:")
			await Pla.Diologue("Glen4", "Broken", "...")
			await Pla.Diologue("Mike", "Neutral", "Ok, Linux got it")
			await Pla.Diologue("Mittens", "Neutral", "Oh my god! I think you killed them.")
		13:
			await Pla.Diologue("Mike", "Neutral", "How hard would it be to recreate this as a Java Game")
			await Pla.Diologue("Mike", "Neutral", "or better yet, as a DS homebrew game?")
			await Pla.Diologue("Mike", "Neutral", "I should probably do that when we get out of here")
		14:
			await Pla.Diologue("Mike", "Neutral", "Phew... so far so good!")
			await Pla.Diologue("Mike", "Neutral", "Hey, that's")
			await Pla.Diologue("Vex", "Neutral", "That blue dog again, of all places...")
			await Pla.Diologue("Mike", "Neutral", "I found you, faker!")
			await Pla.Diologue("Vex", "Neutral", "Faker, I think you're the fake dog around here.")
			await Pla.DiologueE("Vex", "Neutral", "You're comparing yourself to me... ha! You're not even good enough to be my fake.")
			await Pla.Diologue("Mike", "Neutral", "I'll make you eat those words!")
		15:
			await Pla.Diologue("Shibe", "Neutral", "Piss, IDK")
		16:
			await Pla.Diologue("Glen4", "Neutral", "I have a plan!")
			await Pla.Diologue("Athena", "Neutral", "Alright, let's hear it!")
			await Pla.Diologue("Glen4", "Neutral", "A boulder! I need a boulder!")
			await Pla.Diologue("Athena", "Neutral", "how... would that help us?")
			await Pla.Diologue("Glen4", "Neutral", "We put the boulder on a hill, and then roll it down")
			await Pla.Diologue("Athena", "Neutral", "Then that should break the wall and get us out?")
			await Pla.Diologue("Glen4", "Neutral", "Uh... Yes! that was the intended outcome.")
		17:
			await Pla.Diologue("Glen4", "Neutral", "ugh I'm soooo bored")
			await Pla.Diologue("Shibe", "Neutral", "we'll get moving soon.")
			await Pla.Diologue("Glen4", "Neutral", "Like right now?")
			await Pla.Diologue("Shibe", "Neutral", "Just Wait.")
			await Pla.Diologue("Glen4", "Neutral", "But I'm bored!!!!!")
			await Pla.Diologue("Glen4", "Neutral", "[font_size=75]Boooooooooooooooooooooooooooooooored[/font_size]")
			await Pla.Diologue("Glen4", "Neutral", "Bored")
		18:
			await Pla.Diologue("Vex", "Neutral", "So, How about that weather?")
			await Pla.Diologue("Damian", "Neutral", "Vex, this is the 5th time you've said this.")
			await Pla.Diologue("Vex", "Neutral", "Yea, crazy right?")
			await Pla.Diologue("Damian", "Neutral", "Please, say something else.")
		19:
			await Pla.Diologue("Mittens","Neutral", "Hey watch where you spray that Bottle!")
			await Pla.Diologue("Mittens","Neutral", "Don't worry, I only spray things that are Unholy.")
			await Pla.Diologue("Mittens","Neutral", "I can do unholy things")
			await Pla.Diologue("Mittens","Neutral", "...")
			await Pla.Diologue("Mittens","Neutral", "...")
			await Pla.NPCDiologue(null, "[i]Damian Sprays the bottle[/i]")
			await Pla.Diologue("Mittens","Neutral", "[font_size=30]AAAAAAAAAAAAAAAAAAAAAAAAAAA[/font_size]")
		20:
			await Pla.Diologue("Alex","Neutral", "He's a dragon!")
			await Pla.Diologue("Alex","Annoyed", "They're a dragon!")
			await Pla.Diologue("Alex","Angry", "I'm a dragon!")
			await Pla.Diologue("Alex","Annoyed", "are there any other dragons I should know about?")
			await Pla.Diologue("Jimothy","Neutral", "Meow")
		21:
			pass
		22:
			pass
	arr = []
	time = 0
	Pla.EndDiologue()

func calcdio():
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Faelyn") and GameSingleton.CharList.has("Athena"):
		arr.push_back(1)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Faelyn") and GameSingleton.CharList.has("Mittens"):
		arr.push_back(2)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Faelyn") and GameSingleton.CharList.has("Athena"):
		arr.push_back(3)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Faelyn"):
		arr.push_back(4)
	if GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Athena"):
		arr.push_back(5)
	if GameSingleton.CharList.has("Mittens") and GameSingleton.CharList.has("Athena") and GameSingleton.CharList.has("Alex"):
		arr.push_back(6)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Vex"):
		arr.push_back(7)
	if GameSingleton.CharList.has("Faelyn") and GameSingleton.CharList.size() >= 3:
		arr.push_back(8)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Mittens") and GameSingleton.CharList.has("Athena"):
		arr.push_back(9)
	if GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Mittens"):
		arr.push_back(10)
	if GameSingleton.CharList.has("Shibe") and GameSingleton.CharList.has("Alex"):
		arr.push_back(11)
	if GameSingleton.CharList.has("Mike") and GameSingleton.CharList.has("Glen4") and GameSingleton.CharList.has("Mittens"):
		arr.push_back(12)
	if GameSingleton.CharList.has("Mike"):
		arr.push_back(13)
	if GameSingleton.CharList.has("Mike") and GameSingleton.CharList.has("Vex"):
		arr.push_back(14)
	if GameSingleton.CharList.has("Shibe"):
		arr.push_back(15)
	if GameSingleton.CharList.has("Athena") and GameSingleton.CharList.has("Glen4"):
		arr.push_back(16)
	if GameSingleton.CharList.has("Shibe") and GameSingleton.CharList.has("Glen4"):
		arr.push_back(17)
	if GameSingleton.CharList.has("Vex") and GameSingleton.CharList.has("Damian"):
		arr.push_back(18)
	if GameSingleton.CharList.has("Mittens") and GameSingleton.CharList.has("Damian"):
		arr.push_back(19)
	if GameSingleton.CharList.has("Alex") and GameSingleton.CharList.has("Athena") and GameSingleton.CharList.has("Basket") and GameSingleton.CharList.has("Jimothy"):
		arr.push_back(20)
	
	if arr.is_empty():
		arr.push_back(0)
	

func DisplayCon():
	$Player.cutscene = true
	$CLUI/AnimationPlayer.play("DisplayKBM")
	await $Control/AnimationPlayer.animation_finished
	await Signal(self, 'Finished')
	$Control/AnimationPlayer.play("SwitchToController")
	await $Control/AnimationPlayer.animation_finished
	await Signal(self, 'Finished')
	$Control/AnimationPlayer.play("FinishDisplay")
	await $Control/AnimationPlayer.animation_finished
	$Player.cutscene = false
	discon = false

func _input(event):
	if (event.is_action_pressed("skip") and discon):
		Finished.emit()

func SetLabel(N: String):
	$Player/Label.text = N
	$Player/Label.visible = true

func Scare():
	$Player.face(RandDir())
	var Chrs = get_tree().get_nodes_in_group("Character")
	for i in Chrs:
		i.face(RandDir())

func RandDir():
	var dir = rng.randi_range(0,3)
	match dir:
		0:
			return "down"
		1:
			return "left"
		2:
			return "right"
		_:
			return "left"
