extends Node
#Discord rich presence, thanks to vaporvee

# Called when the node enters the scene tree for the first time.
func _ready():#Sets discord Status, sends 
	if(OptionsSingleton.DRP):
		DiscordSDK.clear()
		await get_tree().create_timer(.5).timeout
		DiscordSDK.app_id = 1114659724042965064
		
		DiscordSDK.large_image = "original_campaign_logo" # Image key from "Art Assets"
		DiscordSDK.large_image_text = "O.C."
		DiscordSDK.details = "In " + GameSingleton.Location
		DiscordSDK.small_image = GameSingleton.CharList[0].to_lower() + "icon" # Image key from "Art Assets"
		DiscordSDK.small_image_text = "Playing as: " + GameSingleton.CharList[0]
		
		DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"

		DiscordSDK.refresh() # Always refresh after changing the values!

func Update():
	if(OptionsSingleton.DRP):
		if (get_node_or_null("Player")):
			DiscordSDK.details = "In the Menus"
		else:
			DiscordSDK.details = "In " + GameSingleton.Location
			DiscordSDK.small_image = GameSingleton.CharList[0].to_lower() + "icon" # Image key from "Art Assets"
			DiscordSDK.small_image_text = "Playing as: " + GameSingleton.CharList[0]
	
	
	DiscordSDK.refresh() # Always refresh after changing the values!

func _process(_delta):
	if(OptionsSingleton.DRP):
		DiscordSDK.run_callbacks()
