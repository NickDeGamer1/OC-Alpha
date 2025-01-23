extends Label

var textUpd:float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		textUpd += delta
		if textUpd > 0 and textUpd < 0.5:
			text = "Connecting"
		if textUpd > 0.5 and textUpd < 1:
			text = "Connecting."
		if textUpd > 1.5 and textUpd < 2:
			text = "Connecting.."
		if textUpd > 2.5 and textUpd < 3:
			text = "Connecting..."
		if textUpd > 3.5:
			textUpd = 0
