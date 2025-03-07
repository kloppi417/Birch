#version 120

uniform sampler2D colortex0;

varying vec2 uv;

void main() {
	vec3 color = texture2D(colortex0, uv).rgb;

    float colors = 16.0;
    color.r = floor(color.r * colors) / colors;
    color.g = floor(color.g * colors) / colors;
    color.b = floor(color.b * colors) / colors;

	gl_FragColor = vec4(color, 1.0);
}