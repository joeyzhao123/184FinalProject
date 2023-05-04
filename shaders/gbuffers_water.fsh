#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying float id;
varying vec3 normal;
varying float offset;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
	
	vec4 newcolor = vec4(color.xyz, 0.5);
	/* DRAWBUFFERS:019 */
	gl_FragData[0] = newcolor; // need to map normal to [0, 1], 0 signifies water
	gl_FragData[1] = vec4(0, 0, 0, offset);
	gl_FragData[2] = vec4(normal * 0.5 + 0.5, 1);
}