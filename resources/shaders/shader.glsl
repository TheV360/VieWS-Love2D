uniform float w_time;
uniform vec2 w_scr_size;

#define PI 3.14159265359
#define TAU 6.28318530718

#define saturate(thing) clamp(thing, 0.0, 1.0)

// Function from Iñigo Quiles
// www.iquilezles.org/www/articles/functions/functions.htm
float cubicPulse( float ofs, float width, float x ){
	x = abs(x - ofs);
	if (x > width) return 0.0;
	x /= width;
	return 1.0 - x * x * (3.0 - 2.0 * x);
}

float random(float x) {
	return fract(sin(x) * 100000.0);
}

float crunchyIncorrect(float thing, int steps) {
	return floor(thing * (float(steps) + 0.5)) / float(steps);
}
float crunchy(float thing, int steps) {
	return floor(thing * (float(steps) + 1.0)) / float(steps);
}

float crunchyUnrounded(float thing, int steps) {
	return floor(thing * float(steps)) / float(steps);
}

// Shamelessly stolen from https://www.shadertoy.com/view/XljGzV
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Shamelessly stolen from https://www.shadertoy.com/view/XljGzV
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec2 asScreenPixels(vec2 texture_coords) {
	return floor(texture_coords * w_scr_size) / w_scr_size;
}

vec3 crunchyColors(vec3 color, vec2 texture_coords) {
	vec2 screen_texture_coords = asScreenPixels(texture_coords);
	
	vec3 influence = vec3(1.0 / 32.0);
	float mistakes = random(random((screen_texture_coords.x + 0.5) * (screen_texture_coords.y + 0.5)) + w_time / 1000.0);
	
	color = rgb2hsv(color);
	
	color.x += ((mistakes * 2.0) - 0.5) * influence.x;
	color.yz += vec2(mistakes) * influence.yz;
	color.xyz = vec3(crunchy(color.x, 7), crunchy(color.y, 2), crunchy(color.z, 4));
	
	color.x = mod(color.x, 1.0);
	color.yz = saturate(color.yz);
	
	color = hsv2rgb(color);
	
	return color;
}

vec3 verticalScanlines(float y) {
	return vec3(saturate(sin(mod(y * w_scr_size.y, 1.0) * PI) * 2));
}

vec3 subpixel(float x, float scr_x) {
	x = mod(x * scr_x, 1.0);
	
	float separation = 0.25;
	float width = 0.3;
	
	float blend = 0.6;
	float bland = blend / 3;
	
	// How much each color influences the colors around it
	mat3 influence = mat3(
		1.0, blend, 0.0,
		bland, 1.0, bland,
		0.0, blend, 1.0);
	
	return saturate(vec3(
        cubicPulse(0.5 - separation, width, x),
        cubicPulse(0.5             , width, x),
        cubicPulse(0.5 + separation, width, x)
	) * influence);
}

vec3 dither(vec3 color, vec2 texture_coords, ivec3 crunch_factor) {
	vec2 screen_texture_coords = floor(texture_coords * w_scr_size);
	
	// float spread = pow(sin(w_time/32.0), 2.0);
	float spread = 0.5;
	
	int order[4] = int[4]( 0, 2, 3, 1 ); int order_size = 2;
	// int order[16] = int[16]( 0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5 ); int order_size = 4;
	
	int x = int(mod(screen_texture_coords.x, float(order_size)));
	int y = int(mod(screen_texture_coords.y, float(order_size)));
	
	int index = x + y * order_size;
	
	return saturate(vec3(
		crunchyIncorrect(color.x + float(order[index]) / float(order.length()) * spread / float(crunch_factor.x), crunch_factor.x),
		crunchy(color.y + float(order[index]) / float(order.length()) * spread / float(crunch_factor.y), crunch_factor.y),
		crunchy(color.z + float(order[index]) / float(order.length()) * spread / float(crunch_factor.z), crunch_factor.z)
	));
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	vec4 tex_color = Texel(tex, texture_coords);
	// tex_color.rgb = crunchyColors(tex_color.rgb, texture_coords);
	
	// tex_color.rgb = hsv2rgb(dither(rgb2hsv(tex_color.rgb), texture_coords, ivec3(3)));
	
	tex_color.rgb = hsv2rgb(dither(rgb2hsv(tex_color.rgb), texture_coords, ivec3(2, 1, 1)));
	// tex_color.rgb = dither(tex_color.rgb, texture_coords, ivec3(1));
	
	// CGA pal 0.
	// tex_color.b = 0.25;
	
	// CGA pal 1.
	tex_color.b = max(tex_color.r, tex_color.g);
	
	// tex_color.rgb = hsv2rgb(dither(rgb2hsv(tex_color.rgb), texture_coords, ivec3(256, 1, 4)));
	// tex_color.rgb = vec3((tex_color.r + tex_color.g + tex_color.b) / 3.0);
	
	// vec3 scanline_v = verticalScanlines(texture_coords.y);
	// vec3 subpixels = subpixel(texture_coords.x, w_scr_size.x);
	
	// return tex_color * color * vec4(scanline_v * subpixels, 1.0);
	return tex_color * color;
	// return vec4(scanline_v * subpixels * vec3(0.94 + sin(w_time / 100) * 0.05), 1.0);
}
