#version 130
/*const int colortex0Format  = RGBA16F;   // gcolor */
/*const int colortex4Format  = RGBA16F;   // gaux1 */
/*const int colortex5Format  = RGBA16F;   // gaux2 */

uniform sampler2D gcolor;
uniform sampler2D gaux3;
uniform float viewWidth;
uniform float viewHeight;
varying vec2 texcoord;
#include "/include/post/bloom.glsl"
void main() {
	vec3 color = texture2D(gcolor, texcoord).rgb;
	float blockId = texture2D(gaux3, texcoord).x;
  vec3 bright_color = extract_lights(color, blockId);


/* DRAWBUFFERS:04 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
	gl_FragData[1] = vec4(bright_color, 1.0); //gaux1
}