shader_type canvas_item;

uniform float width = 2.0;
uniform float frequency = 1.5;
uniform float speed = 1.0;

void vertex() {
	VERTEX.x += width * sin((frequency * UV.y) + (speed * TIME));
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
