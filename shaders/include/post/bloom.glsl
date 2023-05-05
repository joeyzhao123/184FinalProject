
const vec3 perceived_weights = vec3(0.2126, 0.7152, 0.0722);
//const vec3 perceived_weights = vec3(0.299, 0.587, 0.114);
const float threshold = .6;
const float sigma2 = pow(2, 2);
const float sigma = 2;
const int radius = 20;
//reference: https://www.rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/

// 1 dimensional gaussian
float gaussian(float x) {
  float a = -0.5 * x * x / sigma2;
  //not necessary to normalize bc we divide by total weight
  //float normalization = 1 / (sqrt(2 * PI * sigma2));
  return exp(a);
}

vec3 extract_lights(vec3 color, float blockId) {
  if (blockId < 10089 + .01f && blockId > 10089 - 0.01f) return color;
  float luminance = dot(perceived_weights, color.rgb);
  if (luminance > threshold) {
      if (blockId < 10090 + .01f && blockId > 10090 - 0.01f) {
        return color;
      }
//      else {
//        return color * 0.15f;
//      }
  }
  return vec3(0);
}
