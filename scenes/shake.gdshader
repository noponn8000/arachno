shader_type canvas_item;

uniform float deformation = 5.0;

void vertex() {
	float spriteWidth = abs(VERTEX.x);
	if (VERTEX.y < 0.0) {
		VERTEX.x += deformation;
	}
}
