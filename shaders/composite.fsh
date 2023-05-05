#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform int isEyeInWater;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 texcoord;

const int shadowMapResolution = 2048;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform sampler2D colortex9;

vec2 DistortPosition(in vec2 position){
    float CenterDistance = length(position);
    float DistortionFactor = mix(1.0f, CenterDistance, 0.9f);
    return position / DistortionFactor;
}

float Visibility(in sampler2D ShadowMap, in vec3 SampleCoords) {
    return step(SampleCoords.z - 0.001f, texture2D(ShadowMap, SampleCoords.xy).r);
}

float cubeLength(vec2 v) {
return pow(abs(v.x * v.x * v.x) + abs(v.y * v.y * v.y), 1.0 / 3.0);
}
    
float getDistortFactor(vec2 v) {
return cubeLength(v) + 0.1;
}

vec3 distort(vec3 v, float factor) {
return vec3(v.xy / factor, v.z * 1.2);
}

vec3 distort(vec3 v) {
return distort(v, getDistortFactor(v.xy));
}

vec3 GetShadow(void){
	vec3 ClipSpace = vec3(texcoord, texture2D(depthtex0, texcoord).r) * 2.0f - 1.0f;
	vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
	vec3 View = ViewW.xyz / ViewW.w;
	vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
	vec4 ShadowSpace = shadowProjection * shadowModelView * World;
	ShadowSpace.xyz = distort(ShadowSpace.xyz);

	vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;
	float ShadowVisibility0 = Visibility(shadowtex0, SampleCoords);
    float ShadowVisibility1 = Visibility(shadowtex1, SampleCoords);
    vec4 ShadowColor0 = texture2D(shadowcolor0, SampleCoords.xy);
    vec3 TransmittedColor = ShadowColor0.rgb * (1.0f - ShadowColor0.a); // Perform a blend operation with the sun color
    return mix(TransmittedColor * ShadowVisibility1, vec3(1.0f), ShadowVisibility0);

}

float isShadow(void){
	vec3 ClipSpace = vec3(texcoord, texture2D(depthtex0, texcoord).r) * 2.0f - 1.0f;
	vec4 ViewW = gbufferProjectionInverse * vec4(ClipSpace, 1.0f);
	vec3 View = ViewW.xyz / ViewW.w;
	vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
	vec4 ShadowSpace = shadowProjection * shadowModelView * World;
	ShadowSpace.xyz = distort(ShadowSpace.xyz);
	vec3 SampleCoords = ShadowSpace.xyz * 0.5f + 0.5f;

    return step(SampleCoords.z - 0.001f, texture2D(shadowtex0, SampleCoords.xy).r);

}

void main() {
	vec3 color = texture2D(colortex0, texcoord).rgb;
    vec2 Lightmap = texture2D(colortex2, texcoord).rg;
    vec3 source = Lightmap.x * Lightmap.x * vec3(1.0f, 0.8f, 0.7f);
    vec3 direct = Lightmap.y * Lightmap.y * vec3(0.05f, 0.15f, 0.3f);
    vec3 lightcolor = source + direct;

    vec3 Normal = normalize(texture2D(colortex1, texcoord).rgb * 2.0f - 1.0f);
    float NdotL = clamp(dot(Normal, normalize(sunPosition)), 0.0f, 1.0f);
    vec3 write = color * clamp((lightcolor + GetShadow() * NdotL + .1f), 0.0f, .8f);

/* DRAWBUFFERS:0 */
	if (texture2D(colortex9, texcoord.st).w == 1) {
		gl_FragData[0] = vec4(color, 1.0) * 0.5;
		return;
	}
	float Depth = texture2D(depthtex0, texcoord).r;
	if(Depth == 1.0f){
		gl_FragData[0] = vec4(color, 1.0f);
		return;
	}

	if (isShadow() < 1 || NdotL <= 0.5f) {

		gl_FragData[0] = vec4(write, 1.0);
	}
	else{
		gl_FragData[0] = vec4(write, 1.0); //gcolor
	}
}