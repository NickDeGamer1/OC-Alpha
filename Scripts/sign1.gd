extends Area2D

@onready var Pla = get_node("../Party/Player")

func interact():
	await Pla.NPCDiologue("res://Textures/Sign.png", "Shut up Alex, or Ill throw you in the water!")
	if GameSingleton.CharList.has("Alex"):
		await Pla.Diologue("Alex", "Worried", "[shake rate=30.0 level=5 connected=1]What does that sign mean by that?[/shake]")
		if GameSingleton.CharList.size() > 1:
			if GameSingleton.CharList[0] == "Alex":
				await Pla.Diologue(GameSingleton.CharList[1], "Neutral", "Don't worry about it.")
			else:
				await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Don't worry about it.")
	else:
		if GameSingleton.CharList[0] != "Aurora":
			await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Alex isn't here right now.")
		else:
			await Pla.Diologue(GameSingleton.CharList[0], "Neutral", "Vulpi, Vulpi Vul.")
	Pla.EndDiologue()
