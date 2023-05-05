#version 120

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
attribute vec2 mc_Entity;
varying float id;
varying vec3 normal;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform int worldTime;  
varying float offset;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
	id = mc_Entity.x;
	normal = gl_NormalMatrix * gl_Normal;
	offset = 0.1 * sin(gl_Position.x * 2);
	if (id == 11111) {
		gl_Position.y +=  0.1 * sin(gl_Position.x * 2 + float(worldTime*0.2));
		gl_Position.x +=  0.1 * cos(gl_Position.z * 2 + float(worldTime*0.2));
	}
}