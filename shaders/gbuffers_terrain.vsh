#version 120

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec3 Normal;
varying vec4 glcolor;
varying vec2 LightmapCoords;
varying float blockId;
uniform int worldTime;  
attribute vec2 mc_Entity;


void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	Normal = gl_NormalMatrix * gl_Normal;
	glcolor = gl_Color;
    LightmapCoords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    LightmapCoords = (LightmapCoords * 33.05f / 32.0f) - (1.05f / 32.0f);

	if (mc_Entity.x == 10018 || mc_Entity.x == 10031) {
		gl_Position.y += 0.05 * sin(gl_Position.x * 2 + float(worldTime*0.2));
	}
	blockId = mc_Entity.x;

}