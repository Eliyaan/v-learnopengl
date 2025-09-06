#version 330 core
@vs vs
layout (location = 0) in vec3 position;

out vec4 vertex_color;

void main() {
	gl_Position = vec4(position, 1.0);
	vertex_color = vec4(0.5, 0.0, 0.0, 1.0);
}
@end

@fs fs
in vec4 vertex_color;

out vec4 FragColor;

void main() {
	FragColor = vertex_color;
}

@end

@program in_out vs fs
