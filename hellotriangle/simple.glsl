#version 330 core
@vs vs
layout (location = 0) in vec3 position;

void main() {
	gl_Position = vec4(position.x, position.y, position.z, 1.0);
}
@end

@fs fs
out vec4 FragColor;

void main() {
	FragColor = vec4(1.0, 0.5, 0.2, 1.0);
}

@end

@program simple vs fs
