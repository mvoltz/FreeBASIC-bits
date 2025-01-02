#include "./glfw3.frog.bi"

Dim as GLFWwindow ptr window_

glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)

glfwInit()
window_ = glfwCreateWindow(800, 600, "LearnOpenGL", 0, 0 )

glfwMakeContextCurrent(window_)
