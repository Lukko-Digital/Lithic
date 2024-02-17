shader_type canvas_item;

uniform vec4 black : source_color;
uniform vec4 dark : source_color;
uniform vec4 mid_dark : source_color;
uniform vec4 mid_light : source_color;
uniform vec4 light : source_color;
uniform vec4 white : source_color;

const int ranges[7] = int[7] (0, 0, 0x3c, 0x64, 0xab, 0xe0, 255);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4[7] colors = { black, black, dark, mid_dark, mid_light, light, white };
	
	float c = textureLod(screen_texture, SCREEN_UV, 0.0).r;
	
	for (int i = 1; i < 7; i++){
		float next_range = float(ranges[i])/255.0;
		if (c <= next_range){
			float prev_range = float(ranges[i-1])/255.0;
			c = c - prev_range;
			c = c * (next_range - prev_range);
			COLOR = colors[i-1] * c + colors[i] * (1.0 - c);
//			COLOR = colors[i];
			break;
		}
	}
	
//	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
}
