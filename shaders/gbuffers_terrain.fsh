#version 120
/*const int colortex4Format  = RGBA16F; */ 
const int R32F = 114;
const int colortex6Format = R32F;
uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 Normal;
varying vec2 LightmapCoords;
varying float blockId;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	
/* DRAWBUFFERS:0126 */
	gl_FragData[0] = color; //gcolor
	gl_FragData[1] = vec4(Normal * 0.5f + 0.5f, 1.0f);
	gl_FragData[2] = vec4(LightmapCoords, 0.0f, 1.0f);
	gl_FragData[3] = vec4(blockId);

}