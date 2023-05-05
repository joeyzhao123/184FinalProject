#version 130

uniform sampler2D gaux1;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

#include "/include/utility/filters.glsl"
void main() {
	//horizontal pass
	vec3 blurred_color = gaussian_filter(true, gaux1);
/* DRAWBUFFERS:5 */
	gl_FragData[0] = vec4(blurred_color.rgb, 1.0); //gaux2
}