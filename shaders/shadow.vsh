#version 120

varying vec2 uv;
varying vec4 color;
varying vec2 texcoord;

vec2 DistortPosition(in vec2 position){
    float CenterDistance = length(position);
    float DistortionFactor = mix(1.0f, CenterDistance, 0.90f);
    return position / DistortionFactor;
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

void main() {
    gl_Position = ftransform();
    gl_Position.xyz = distort(gl_Position.xyz);
    texcoord = gl_MultiTexCoord0.st;
    color = gl_Color;
}