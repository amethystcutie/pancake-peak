#define FLT_MAX 3.402823466e+38

shader_type canvas_item;
render_mode unshaded;

// Annoyingly, since this is set at compile, it seems you need to manually
// set this array size to match the number of colors in your array. Otherwise
// it will disregard the 'extra' colors
uniform vec4[18] colors : source_color;

uniform int pixelate_amount = 100;
uniform vec4 outline_color : source_color;
uniform float offset: hint_range(0.0, 10.0);

// RGB to LAB implementation from
// https://github.com/sv3/gift/blob/master/RGB2Lab.glsl
vec3 rgb_to_lab(vec4 rgb){
	float R = rgb.x;
	float G = rgb.y;
	float B = rgb.z;
	// threshold
	float T = 0.008856;

	float X = R * 0.412453 + G * 0.357580 + B * 0.180423;
	float Y = R * 0.212671 + G * 0.715160 + B * 0.072169;
	float Z = R * 0.019334 + G * 0.119193 + B * 0.950227;

	// Normalize for D65 white point
	X = X / 0.950456;
	Y = Y;
	Z = Z / 1.088754;

	bool XT, YT, ZT;
	XT = false; YT=false; ZT=false;
	if(X > T) XT = true;
	if(Y > T) YT = true;
	if(Z > T) ZT = true;

	float Y3 = pow(Y,1.0/3.0);
	float fX, fY, fZ;
	if(XT){ fX = pow(X, 1.0/3.0);} else{ fX = 7.787 * X + 16.0/116.0; }
	if(YT){ fY = Y3; } else{ fY = 7.787 * Y + 16.0/116.0 ; }
	if(ZT){ fZ = pow(Z,1.0/3.0); } else{ fZ = 7.787 * Z + 16.0/116.0; }

	float L; if(YT){ L = (116.0 * Y3) - 16.0; }else { L = 903.3 * Y; }
	float a = 500.0 * ( fX - fY );
	float b = 200.0 * ( fY - fZ );

	return vec3(L,a,b);
}

void fragment() {
	float aspect = (1.0 / TEXTURE_PIXEL_SIZE.x) / (1.0 / TEXTURE_PIXEL_SIZE.y);
	
	vec2 grid = vec2(float(pixelate_amount) * aspect, float(pixelate_amount));
	vec2 grid_uv = round(UV * grid) / grid;
	
	vec2 uv = grid_uv;
	vec2 halfpixel = TEXTURE_PIXEL_SIZE / 2.0;
	vec4 sum = texture(TEXTURE, uv + vec2(-halfpixel.x * 2.0, 0.0) * offset);
	sum += texture(TEXTURE, uv + vec2(-halfpixel.x, halfpixel.y) * offset) * 2.0;
	sum += texture(TEXTURE, uv + vec2(0.0, halfpixel.y * 2.0) * offset);
	sum += texture(TEXTURE, uv + vec2(halfpixel.x, halfpixel.y) * offset) * 2.0;
	sum += texture(TEXTURE, uv + vec2(halfpixel.x * 2.0, 0.0) * offset);
	sum += texture(TEXTURE, uv + vec2(halfpixel.x, -halfpixel.y) * offset) * 2.0;
	sum += texture(TEXTURE, uv + vec2(0.0, -halfpixel.y * 2.0) * offset);
	sum += texture(TEXTURE, uv + vec2(-halfpixel.x, -halfpixel.y) * offset) * 2.0;
	
	vec4 color = sum / 12.0;
	
	float min_dist = FLT_MAX;
	for(int i=0;i<colors.length(); i++) {
		float dist = distance(
			rgb_to_lab(color),
			rgb_to_lab(colors[i])
		);
		if (dist < min_dist) {
			min_dist = dist;
			COLOR = colors[i];
			COLOR.a = float(int(color.a));
			
			vec2 pixel_step = vec2(1.0 / float(pixelate_amount));
			
			if (int(color.a) == 0) {
				float neighbour_alpha = 0.0;
				neighbour_alpha += texture(TEXTURE, grid_uv + vec2(pixel_step.x, 0.0)).a;
				neighbour_alpha += texture(TEXTURE, grid_uv - vec2(pixel_step.x, 0.0)).a;
				neighbour_alpha += texture(TEXTURE, grid_uv + vec2(0.0, pixel_step.x)).a;
				neighbour_alpha += texture(TEXTURE, grid_uv - vec2(0.0, pixel_step.x)).a;
				
				if (neighbour_alpha > 0.0) {
					COLOR = outline_color;
				}
			}
		}
	}
}
