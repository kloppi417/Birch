#version 330 compatibility

#define PI 3.14159265358979323846

uniform sampler2D colortex0;

uniform float viewWidth;
uniform float viewHeight;
vec2 view = vec2(viewWidth, viewHeight);

in vec2 uv;

// Gaussian Variables
const float range_sigma = 0.3;
const float spatial_sigma = 2.5;
const int kernelSize = 11;

float calculateGaussianWeight(float dist, float sigma) {
    float coeffecient = 1.0 / (2.0 * PI * sigma * sigma);
    float exponent = - (dist * dist) / (2 * sigma * sigma);
    return coeffecient * exp(exponent);
}

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {

    color = vec4(0.0, 0.0, 0.0, 1.0);
	
    int bound = int(kernelSize / 2);

    float normalization = 0.0;
    vec3 pixelColor = texture2D(colortex0, uv).rgb;

    for (int x = -bound; x <= bound; x++) {
        for (int y = -bound; y <= bound; y++) {
            vec2 neighborCoords = uv + vec2(x, y) / view;
            vec3 neighborColor = texture2D(colortex0, neighborCoords).rgb;

            float spatialDistance = length(vec2(x, y));
            float colorDistance   = length(pixelColor - neighborColor);
            
            float spatialWeight = calculateGaussianWeight(spatialDistance, spatial_sigma);
            float rangeWeight   = calculateGaussianWeight(colorDistance,   range_sigma);

            color.rgb += neighborColor * spatialWeight * rangeWeight;
            normalization += spatialWeight * rangeWeight;
        }
    }

    color *= 1.0 / normalization;
}