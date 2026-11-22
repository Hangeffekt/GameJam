shader_type canvas_item;

uniform float shine_progress: hint_range(-0.3, 1.3) = -0.3;
uniform float shine_width: hint_range(0.02, 0.5) = 0.12;
uniform vec4 shine_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shine_strength: hint_range(0.0, 2.0) = 0.85;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	float coord = (UV.x + UV.y * 0.35);
	float d = abs(coord - shine_progress);
	float shine = 1.0 - smoothstep(0.0, shine_width, d);
	base.rgb += shine_color.rgb * shine * shine_strength;
	COLOR = base;
}
