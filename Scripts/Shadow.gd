extends AnimatedSprite2D

#Shadow: Dispite name, contains abilitys

@onready var sha = $LightOccluder2D
@export var canBlink: bool = true
@export var Ccolor:Color
var charname = GameSingleton.FullCharList[0]
var rng = RandomNumberGenerator.new()
var blinknum: int = rng.randi_range(3,5)
var blinktime= 0
var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

# Called when the node enters the scene tree for the first time.
func _ready():
	updateshadow(charname)
	if (OptionsSingleton.Shadows != 0):
		$LightOccluder2D.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var num = frame#Sets frame of anim
	if num == 2:
		num = 0
	elif num == 3:
		num = 2
	if is_playing() and OptionsSingleton.Shadows == 0:#Sets shadow of player
		sha.occluder = load("res://Prefabs/Characters/"+ 
			charname + "/Occluder/" + animation + str(num) + ".tres")
	elif get_node("../").name == "MPsprite":
		sha.occluder = load("res://Prefabs/Characters/"+ 
			charname + "/Occluder/" + animation + str(num) + ".tres")
	
	if animation.contains("move_"):#Updates position of sprite based on frame
		match frame:
			1:
				position.y = -3
			3:
				position.y = -3
			_:
				position.y = 0
	
	blinktime += delta#Blinks
	if blinktime > blinknum:
		blink()

func blink():#Blinks based on direction
	if canBlink:
		if get_parent().name != "EncloseSPR":
			if !get_parent().moving and !get_parent().cutscene:
				if get_node_or_null("Eyelids") != null and get_node_or_null("EyelidR") != null and get_node_or_null("EyelidL") != null and animation.contains("move_"):
					match get_parent().direction:
						"down":
							$Eyelids.visible = true
							await get_tree().create_timer(.1).timeout
							$Eyelids.visible = false
						"left":
							$EyelidL.visible = true
							await get_tree().create_timer(.1).timeout
							$EyelidL.visible = false
						"right":
							$EyelidR.visible = true
							await get_tree().create_timer(.1).timeout
							$EyelidR.visible = false
					blinknum = rng.randi_range(3,5)
					blinktime = 0
		else:
			if !get_node("../../").moving and !get_node("../../").cutscene:
				if get_node_or_null("Eyelids") != null and get_node_or_null("EyelidR") != null and get_node_or_null("EyelidL") != null and animation.contains("move_"):
					match get_node("../../").direction:
						"down":
							$Eyelids.visible = true
							await get_tree().create_timer(.1).timeout
							$Eyelids.visible = false
						"left":
							$EyelidL.visible = true
							await get_tree().create_timer(.1).timeout
							$EyelidL.visible = false
						"right":
							$EyelidR.visible = true
							await get_tree().create_timer(.1).timeout
							$EyelidR.visible = false
		blinknum = rng.randi_range(3,5)
		blinktime = 0

func face(dir):#Sprite faces direction
	if dir.contains("move_"):
		animation = dir
	else:
		animation = "move_" + dir
	stop()
	frame = 0
	if (OptionsSingleton.Shadows == 0):
		if dir.contains("move_"):
			sha.occluder = load("res://Prefabs/Characters/" + charname + "/Occluder/" + dir + "0.tres")
		else:
			sha.occluder = load("res://Prefabs/Characters/" + charname + "/Occluder/move_" + dir + "0.tres")

func updateshadow(CharName):#Updates shadow of scharacter
	if (OptionsSingleton.Shadows == 0):
		charname = CharName
		sha = $LightOccluder2D
		if get_parent().name == "EncloseSPR":
			sha.occluder = load("res://Prefabs/Characters/"+ charname + "/Occluder/move_" + get_node("../../").direction + "0" + ".tres")
		else:
			sha.occluder = load("res://Prefabs/Characters/"+ charname + "/Occluder/move_" + get_node("../").direction + "0" + ".tres")

func Ability(Char, Dir):#Does character abilities
	var ts
	if "tile_size" in get_node("../../"):
		ts = get_node("../../").tile_size
	else:
		ts = 96
	match Char:
		"Alex":#Spawns Aurora, Aurora looks for Freezable squares
			if(get_node_or_null("TempSprite") != null):
				play("Pokeball_" + Dir)
				get_node("../../RayCast2D").target_position = inputs["move_" + Dir] * ts
				get_node("../../RayCast2D").force_raycast_update()
				if !get_node("../../RayCast2D").is_colliding():
					get_node("TempSprite").position = (position + inputs["move_" + Dir] * ts)/3
					get_node("TempSprite").loadSprite("Aurora")
					get_node("TempSprite").face(Dir)
					get_node("TempSprite").visible = true
					get_node("TempSprite/AnimationPlayer").play("appear")
					await get_node("TempSprite/AnimationPlayer").animation_finished
					await get_node("TempSprite").freeze()
				else:
					get_node("cant" + Dir).visible = true
					await get_tree().create_timer(.5).timeout
					get_node("cant" + Dir).visible = false
				animation = "move_" + Dir
				frame = 0
				face(Dir)
		"Faelyn":#Plays anim, Sees all glass walls in area, broadcasts if in
			face("down")
			Sing()
			await $SingRadius.Activate()
			animation = "move_" + Dir
			frame = 0
			face("down")
			stop()
		"Athena":#Creates gust of wind, plays anim
			play("ability_" + Dir)
			await get_tree().create_timer(.3).timeout
			var scene = load("res://Prefabs/gust_of_wind.tscn")
			var child_node = scene.instantiate()
			child_node.position = self.global_position
			get_tree().get_root().add_child(child_node)
			child_node.Go(Dir)
			$WindSound.play()
			face(Dir)
		"Vex":#PLays anim, sees if surrounded by speakers, plays speakers
			var col1:bool = false
			var col2:bool = false
			var ray = get_node("../../RayCast2D")
			ray.target_position = inputs["move_left"] * 96
			ray.force_raycast_update()
			face("left")
			if ray.is_colliding():
					if ray.get_collider().name == "Speakers":
						col1 = true
			ray.target_position = inputs["move_left"] * 96
			await get_tree().create_timer(.5).timeout
			ray.force_raycast_update()
			face("right")
			if ray.is_colliding():
					if ray.get_collider().name == "Speakers":
						col2 = true
			await get_tree().create_timer(.5).timeout
			face("down")
			if col1 and col2:
				play("Strum")
				await get_tree().create_timer(.15).timeout
				await ray.get_collider().get_node("../").Play()
			face("down")
		"Shibe":#Sniffs area
			await sniff(Dir)
		"Damian":#Sprays area
			await spray(Dir)
		"Glen4":#Punches area
			await Punch(Dir)
		"Aurora":#Freezes area
			await freeze(Dir)
		_:#Plays audio if no ability exists
			if !get_node("../../AudioStreamPlayer2D").playing:
				get_node("../../AudioStreamPlayer2D").play()

func Sing():
	if (OptionsSingleton.Shadows == 0):
		match GameSingleton.CharList[0]:
			"Faelyn":
				play("Sing")
				sha.occluder = load("res://Prefabs/Characters/Faelyn/Occluder/Sing0.tres")

func sniff(dir:String):
	animation = "move_" + dir
	$LightOccluder2D.occluder = load("res://Prefabs/Characters/Shibe/Occluder/move_" + dir +"0.tres")
	play("Sniff_" + dir)
	$AudioStreamPlayer2D2.play()
	for i in get_node("Sniff_" + dir).get_overlapping_areas():
		if !i.name.contains("Sniff"):
			i.sniffOut()
	await get_tree().create_timer(1).timeout
	stop()
	$AudioStreamPlayer2D2.stop()
	animation = "move_" + dir
	$LightOccluder2D.occluder = load("res://Prefabs/Characters/Shibe/Occluder/move_" + dir +"0.tres")
	frame = 0

func spray(dir:String):
	animation = "move_" + dir
	$LightOccluder2D.occluder = load("res://Prefabs/Characters/Shibe/Occluder/move_" + dir +"0.tres")
	play("spray_" + dir)
	$SpPlayer.play("spray_" + dir)
	for i in get_node("SP_" + dir).get_overlapping_areas():
		if i.name.contains("Corroded"):
			i.clean()
	await $SpPlayer.animation_finished
	animation = "move_" + dir
	pause()
	$LightOccluder2D.occluder = load("res://Prefabs/Characters/Damian/Occluder/move_" + dir +"0.tres")
	frame = 0

func Punch(dir:String):
	if !$PunchSFX.playing and !$AnimationPlayer.is_playing():
		animation = "move_" + dir
		$LightOccluder2D.occluder = load("res://Prefabs/Characters/Glen4/Occluder/move_" + dir +"0.tres")
		play("punch_" + dir)
		$PunchSFX.play()
		await $PunchSFX.finished
		for i in get_node("Punch_" + dir).get_overlapping_areas():
			if i.name.contains("Punchable"):
				i.punched()
		animation = "move_" + dir
		pause()
		$LightOccluder2D.occluder = load("res://Prefabs/Characters/Glen4/Occluder/move_" + dir +"0.tres")
		frame = 0

func freeze(direction:String):
	var ray = get_node("../../RayCast2D")
	ray.target_position = inputs["move_" + direction] * 96
	ray.force_raycast_update()
	if ray.is_colliding() and ray.get_collider().has_method("Freeze"):
		$AnimationPlayer.play("wind_"+ direction)
		await $AnimationPlayer.animation_finished
		ray.get_collider().Freeze()
