extends Area2D

var frozen = false

var ref1
var ref2
var ref3

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


func Freeze():
	frozen = true
	$CollisionShape2D.disabled = true
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.visible = false


func _process(_delta: float) -> void:
	if OptionsSingleton.Shadows == 0 and $AnimatedSprite2D/Reflection1.visible:
		$AnimatedSprite2D/Reflection1.global_position = ref1.global_position + Vector2(0,85)
		var anima
		if ref1.name.contains("PlayerCollider"):
			anima = ref1.get_node("../EncloseSPR/AnimatedSprite2D")
		elif ref1.name.contains("PM"):
			anima = ref1.get_node("../AnimatedSprite2D")
		var frameIndex: int = anima.get_frame()
		var animationName: String = anima.animation
		var spriteFrames: SpriteFrames = anima.get_sprite_frames()
		var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
		$AnimatedSprite2D/Reflection1.texture = currentTexture
	if OptionsSingleton.Shadows == 0 and $AnimatedSprite2D/Reflection2.visible:
		$AnimatedSprite2D/Reflection2.global_position = ref2.global_position + Vector2(0,85)
		var anima
		if ref2.name.contains("PlayerCollider"):
			anima = ref2.get_node("../EncloseSPR/AnimatedSprite2D")
		else:
			anima = ref2.get_node("../AnimatedSprite2D")
		var frameIndex: int = anima.get_frame()
		var animationName: String = anima.animation
		var spriteFrames: SpriteFrames = anima.get_sprite_frames()
		var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
		$AnimatedSprite2D/Reflection2.texture = currentTexture
	if OptionsSingleton.Shadows == 0 and $AnimatedSprite2D/Reflection3.visible:
		$AnimatedSprite2D/Reflection3.global_position = ref3.global_position + Vector2(0,85)
		var anima
		if ref3.name.contains("PlayerCollider"):
			anima = ref3.get_node("../EncloseSPR/AnimatedSprite2D")
		else:
			anima = ref3.get_node("../AnimatedSprite2D")
		var frameIndex: int = anima.get_frame()
		var animationName: String = anima.animation
		var spriteFrames: SpriteFrames = anima.get_sprite_frames()
		var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
		$AnimatedSprite2D/Reflection3.texture = currentTexture

func _on_area_2d_area_entered(area: Area2D) -> void:
	if OptionsSingleton.Shadows == 0:
		if area.name.contains("PlayerCollider"):
			var anima = area.get_node("../EncloseSPR/AnimatedSprite2D")
			var frameIndex: int = anima.get_frame()
			var animationName: String = anima.animation
			var spriteFrames: SpriteFrames = anima.get_sprite_frames()
			var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
			if !$AnimatedSprite2D/Reflection1.visible:
				ref1 = area
				$AnimatedSprite2D/Reflection1.texture = currentTexture
				$AnimatedSprite2D/Reflection1.visible = true
			elif !$AnimatedSprite2D/Reflection2.visible:
				ref2 = area
				$AnimatedSprite2D/Reflection2.texture = currentTexture
				$AnimatedSprite2D/Reflection2.visible = true
			else:
				ref3 = area
				$AnimatedSprite2D/Reflection3.texture = currentTexture
				$AnimatedSprite2D/Reflection3.visible = true
		elif area.name.contains("PM"):
			var anima = area.get_node("../AnimatedSprite2D")
			var frameIndex: int = anima.get_frame()
			var animationName: String = anima.animation
			var spriteFrames: SpriteFrames = anima.get_sprite_frames()
			var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
			if !$AnimatedSprite2D/Reflection1.visible:
				ref1 = area
				$AnimatedSprite2D/Reflection1.texture = currentTexture
				$AnimatedSprite2D/Reflection1.visible = true
			elif $AnimatedSprite2D/Reflection2.visible:
				ref2 = area
				$AnimatedSprite2D/Reflection2.texture = currentTexture
				$AnimatedSprite2D/Reflection2.visible = true
			else:
				ref3 = area
				$AnimatedSprite2D/Reflection3.texture = currentTexture
				$AnimatedSprite2D/Reflection3.visible = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name.contains("PlayerCollider"):
		if ref1 == area:
			$AnimatedSprite2D/Reflection1.visible = false
		elif ref2 == area:
			$AnimatedSprite2D/Reflection2.visible = false
		elif ref3 == area:
			$AnimatedSprite2D/Reflection3.visible = false
	elif area.name.contains("PM"):
		if ref1 == area:
			$AnimatedSprite2D/Reflection1.visible = false
		elif ref2 == area:
			$AnimatedSprite2D/Reflection2.visible = false
		elif ref3 == area:
			$AnimatedSprite2D/Reflection3.visible = false
