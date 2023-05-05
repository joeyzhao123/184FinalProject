#version 120

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform vec3 fogColor;
uniform int worldTime;

varying vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.
varying vec3 mySkyColor;
varying vec3 mySunColor;
varying float isNight;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, gbufferModelView[1].xyz); //not much, what's up with you?
    vec3 nativeColor = mix(mySkyColor, fogColor, fogify(max(upDot, 0.0), 0.25));

    vec3 normPos = normalize(pos);
    vec3 normSun = normalize(sunPosition);
	float distToSun = clamp(dot(normPos, normSun), 0.0, 1.0);
	vec3 normMoon = normalize(moonPosition);
	float distToMoon = clamp(dot(normPos, normMoon), 0.0, 1.0);

	vec3 finalColor;
	if (isNight < 0.9) {
		finalColor = nativeColor + pow(distToSun, 150) * mySunColor * (1-isNight);
	} else {
		finalColor = nativeColor + pow(distToMoon, 10) * mySunColor * isNight;
	}

    return finalColor;
}

void main() {
	vec3 color;
	if (starData.a > 0.5) {
		color = starData.rgb;
	}
	else {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = gbufferProjectionInverse * pos;
		color = calcSkyColor(normalize(pos.xyz));
	}

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}