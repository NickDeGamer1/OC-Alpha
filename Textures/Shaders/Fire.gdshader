shader_type canvas_item;

uniform float hight = 3.0;
uniform float frequency = 1;
uniform float speed = 10.0;

void vertex() {
	VERTEX.x += hight * sin((frequency * UV.y) + (speed * TIME));
}