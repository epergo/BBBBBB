shader_type canvas_item;

uniform float percent : hint_range(0, 1);
uniform sampler2D wipeImage;

// WHITE IS 1
// BLACK IS 0

void fragment() {
	float textVal = texture(wipeImage, UV).r;

	if (textVal < percent) {
		COLOR.a = 0.0;
	} else if (textVal == percent && percent == 1.0) {
		COLOR.a = 0.0;
	}
}
