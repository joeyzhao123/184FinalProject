#version 130

uniform sampler2D gaux1;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

#include "/include/utility/filters.glsl"
void main() {
	//downsample and upsample
	//vec3 blurred_color = downsample(gaux1);
	vec3 blurred_color = box_filter(gaux1, 4);
/* DRAWBUFFERS:5 */
	gl_FragData[0] = vec4(blurred_color.rgb, 1.0); //gaux2
}