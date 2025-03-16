extends Node

#List of playable, complete and current players

var FullCharList = ["Alex", "Faelyn", "Athena", "Vex", "Mittens", "Mike", "Shibe", "Glen4", "Damian", "Jimothy","Socks", "Treasure", "Blitz", "Conrad", "Basket", "Emmet", "Syndrome"]
var CompleteListCharList = ["Alex", "Faelyn", "Athena", "Vex", "Mittens", "Mike", "Shibe", "Glen4", "Damian"]
var CharList = ["Aurora"]

var Location
var music
var musicTime:float = 0.0

func swapChar():#sets characters back
	var temp
	temp = CharList[0]
	for n in CharList.size() - 1:
		CharList[n] = CharList[n+1]
	CharList[CharList.size() - 1] = temp

func revSwapChar():#sets characters forward
	var temp
	temp = CharList[CharList.size() - 2]
	var n:int = CharList.size() - 1
	while n > 0:
		CharList[n - 1] = CharList[n]
		CharList[n] = temp
		temp = CharList[n - 2]
		n-=1
