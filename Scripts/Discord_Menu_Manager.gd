extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	if(OptionsSingleton.DRP):
		DiscordSDK.clear()
		DiscordSDK.app_id = 1114659724042965064
		
		DiscordSDK.large_image = "original_campaign_logo" # Image key from "Art Assets"
		DiscordSDK.large_image_text = "O.C."
		DiscordSDK.details = "In the Menus"
		
		DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"

		DiscordSDK.refresh() # Always refresh after changing the values!

func Update():
	if(OptionsSingleton.DRP):
		
		DiscordSDK.refresh() # Always refresh after changing the values!

func _process(_delta):
	if(OptionsSingleton.DRP):
		DiscordSDK.run_callbacks()
