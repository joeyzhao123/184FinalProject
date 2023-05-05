#version 130

uniform sampler2D gaux2;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

#include "/include/utility/filters.glsl"
void main() {
	vec3 blurred_color = gaussian_filter(false, gaux2);
	//testing if blur happens
/* DRAWBUFFERS:4 */
	gl_FragData[0] = vec4(blurred_color, 1.0); //gaux1
}