extends Node

var Multip:bool = false
var MPhost: bool = false
var MPName:String
var ip:String = "127.0.0.1"
var id:int
var port = 8910
var Players = {}
var PlayerPing = {}
var peer
var Kicked:bool = false
var KR:String
