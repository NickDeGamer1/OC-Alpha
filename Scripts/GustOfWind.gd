extends Area2D

var active: bool = false
var speed:int = 4
var dir: String = "down"
var tile_size: int = 96
var moving: bool = false

var inputs = {"move_right": Vector2.RIGHT,
			"move_left": Vector2.LEFT,
			"move_up": Vector2.UP,
			"move_down": Vector2.DOWN}

func _process(_delta):
	if active and !moving:
		Move()

func Go(dirinp):
	dir = dirinp
	match dir:
		"right":
			$Sprite2D.flip_h = true
		"up":
			$Sprite2D.rotation = 90
		"down":
			$Sprite2D.rotation = -90
			$Sprite2D.flip_v = true
	active = true

func Move():
	moving = true
	var tween = create_tween()
	tween.tween_property(self, "position",position + inputs["move_" + dir] * tile_size, .125).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	moving = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if (area.name.contains("Area")):
		queue_free()
