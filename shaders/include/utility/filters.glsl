const int radius = 45;
const float sigma2 = 2;
float gaussian(float x) {
  float a = -0.5 * x * x / sigma2;
  return exp(a);
}
// requires we have viewWidth, viewHeight, and the bright colors stored in the composite buffer
vec3 gaussian_filter(bool horizontal, sampler2D tex) {
    vec2 texelSize = 1.0f / textureSize(tex, 0);
    vec3 color = vec3(0.0);
    float totalWeight = 0.0;
    for (int i = -radius; i <= radius; i++) {
        vec2 offset = (horizontal) ? vec2(float(i) * texelSize.x, 0.0) : vec2(0.0, float(i) * texelSize.y);
        float weight = gaussian(i);
        color += texture2D(tex, texcoord + offset).rgb * weight;
        //color += texture2D(tex, texcoord + offset).rgb * weight;
        totalWeight += weight;
    }
    color /= totalWeight;
    return color;
}
vec3 box_filter(sampler2D tex, int spread) {
    vec4 sum = texture2D(tex, texcoord);
    vec2 texelSize = 1.0 / textureSize(tex, 0) * spread;
    float x = texelSize.x;
    float y = texelSize.y;
    for (int i = 0; i < 5; i++) {
        sum += texture2D(tex, texcoord + y);
        sum += texture2D(tex, texcoord - y);
        sum += texture2D(tex, texcoord + x);
        sum += texture2D(tex, texcoord - x);
        sum /= 5.0;
    }
    return sum.rgb;
}

vec4 downsample(sampler2D tex) {
    vec2 texelSize = 1.0 / textureSize(tex, 0);
    float x = texelSize.x;
    float y = texelSize.y;

    vec3 a = texture(tex, vec2(texcoord.x - 2*x, texcoord.y + 2*y)).rgb;
    vec3 b = texture(tex, vec2(texcoord.x,       texcoord.y + 2*y)).rgb;
    vec3 c = texture(tex, vec2(texcoord.x + 2*x, texcoord.y + 2*y)).rgb;

    vec3 d = texture(tex, vec2(texcoord.x - 2*x, texcoord.y)).rgb;
    vec3 e = texture(tex, vec2(texcoord.x,       texcoord.y)).rgb;
    vec3 f = texture(tex, vec2(texcoord.x + 2*x, texcoord.y)).rgb;

    vec3 g = texture(tex, vec2(texcoord.x - 2*x, texcoord.y - 2*y)).rgb;
    vec3 h = texture(tex, vec2(texcoord.x,       texcoord.y - 2*y)).rgb;
    vec3 i = texture(tex, vec2(texcoord.x + 2*x, texcoord.y - 2*y)).rgb;

    vec3 j = texture(tex, vec2(texcoord.x - x, texcoord.y + y)).rgb;
    vec3 k = texture(tex, vec2(texcoord.x + x, texcoord.y + y)).rgb;
    vec3 l = texture(tex, vec2(texcoord.x - x, texcoord.y - y)).rgb;
    vec3 m = texture(tex, vec2(texcoord.x + x, texcoord.y - y)).rgb;

    vec3 color = e*0.125;
    color += (a+c+g+i)*0.03125;
    color += (b+d+f+h)*0.0625;
    color += (j+k+l+m)*0.125;
		return vec4(color, 1.0f);

}
vec4 gaussian_approx(sampler2D tex) {
    float x = radius;
    float y = radius;

    vec3 a = texture(tex, vec2(texcoord.x - x, texcoord.y + y)).rgb;
    vec3 b = texture(tex, vec2(texcoord.x,     texcoord.y + y)).rgb;
    vec3 c = texture(tex, vec2(texcoord.x + x, texcoord.y + y)).rgb;

    vec3 d = texture(tex, vec2(texcoord.x - x, texcoord.y)).rgb;
    vec3 e = texture(tex, vec2(texcoord.x,     texcoord.y)).rgb;
    vec3 f = texture(tex, vec2(texcoord.x + x, texcoord.y)).rgb;

    vec3 g = texture(tex, vec2(texcoord.x - x, texcoord.y - y)).rgb;
    vec3 h = texture(tex, vec2(texcoord.x,     texcoord.y - y)).rgb;
    vec3 i = texture(tex, vec2(texcoord.x + x, texcoord.y - y)).rgb;

    // Apply weighted distribution, by using a 3x3 tent filter:
    //  1   | 1 2 1 |
    // -- * | 2 4 2 |
    // 16   | 1 2 1 |
    vec3 color = e*4.0;
    color += (b+d+f+h)*2.0;
    color += (a+c+g+i);
    color *= 1.0 / 16.0;
    return vec4(color, 1.0);
}
