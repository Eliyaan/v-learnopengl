#version 330 core
@vs vs
layout (location = 0) in vec3 position;

void main() {
	gl_Position = vec4(position, 1.0);
}
@end

@fs fs
layout (binding = 0) uniform fs_params {
	vec4 our_color;
};

out vec4 FragColor;

void main() {
	FragColor = our_color;
}

@end

@program uniforms vs fs
