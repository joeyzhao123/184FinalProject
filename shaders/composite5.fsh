#version 130

uniform sampler2D gaux2;
uniform sampler2D gcolor;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;

#include "/include/utility/filters.glsl"
void main() {
	vec3 blurred_color = box_filter(gaux2, 4);
	vec3 color = texture2D(gcolor, texcoord).rgb + blurred_color.rgb;

	//testing if blur happens
/* DRAWBUFFERS:0*/
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}