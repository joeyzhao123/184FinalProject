#version 120

uniform sampler2D gcolor;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform sampler2D colortex9;
uniform sampler2D texture;
uniform int isEyeInWater; 
varying vec2 texcoord;



vec3 projectanddivide(mat4 projectionmatrix, vec3 pos) {
	vec4 homogpos = projectionmatrix * vec4(pos, 1.0);
	return homogpos.xyz / homogpos.w;
}

void main() {
	vec3 color = texture2D(gcolor, texcoord).rgb;
	vec3 screenpos = vec3(texcoord, texture2D(depthtex0, texcoord));
	vec3 ndcpos = screenpos * 2.0 - 1.0;
	vec3 viewpos = projectanddivide(gbufferProjectionInverse, ndcpos);
	vec3 feetplayerpos = (gbufferModelViewInverse * vec4(viewpos, 1.0)).xyz;
	vec3 worldpos = feetplayerpos + cameraPosition;
	vec3 normal = texture2D(colortex9, texcoord.st).xyz * 2.0 - 1.0;
	vec3 dir = reflect(viewpos, normal) * 0.1;
	if (texture2D(colortex9, texcoord.st).w == 1 && (isEyeInWater != 1)) {
		vec3 pos = viewpos;
		for (int i=0; i < 32; i++) {
			vec3 screenpos = projectanddivide(gbufferProjection, pos) * 0.5 + 0.5;
			float depth = texture2D(depthtex0, screenpos.st).x;
			float thickness = screenpos.z-depth;
			if (thickness > 0 && thickness < 0.5) {
				if (screenpos.x > 1 || screenpos.x < 0 || screenpos.y < 0 || screenpos.y > 1) {
					break;
				}
				vec3 ssrcolor = texture2D(texture, screenpos.st).rgb;
				float blending = 0.5;
				blending -= abs(screenpos.x - 0.5);
				if (ssrcolor == color) {
					break;
				}
				color = mix(color, ssrcolor, blending);
				break;
			}
			pos += dir;
		}
	}

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0);
}