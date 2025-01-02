#pragma once

#include once "GL/gl.bi"

extern "C"

#define _glfw3_h_

#define APIENTRY
#define GLFW_APIENTRY_DEFINED

#define GLFWAPI
const GLFW_VERSION_MAJOR = 3
const GLFW_VERSION_MINOR = 4
const GLFW_VERSION_REVISION = 0
const GLFW_TRUE = 1
const GLFW_FALSE = 0
const GLFW_RELEASE = 0
const GLFW_PRESS = 1
const GLFW_REPEAT = 2
const GLFW_HAT_CENTERED = 0
const GLFW_HAT_UP = 1
const GLFW_HAT_RIGHT = 2
const GLFW_HAT_DOWN = 4
const GLFW_HAT_LEFT = 8
const GLFW_HAT_RIGHT_UP = GLFW_HAT_RIGHT or GLFW_HAT_UP
const GLFW_HAT_RIGHT_DOWN = GLFW_HAT_RIGHT or GLFW_HAT_DOWN
const GLFW_HAT_LEFT_UP = GLFW_HAT_LEFT or GLFW_HAT_UP
const GLFW_HAT_LEFT_DOWN = GLFW_HAT_LEFT or GLFW_HAT_DOWN
const GLFW_KEY_UNKNOWN = -1
const GLFW_KEY_SPACE = 32
const GLFW_KEY_APOSTROPHE = 39
const GLFW_KEY_COMMA = 44
const GLFW_KEY_MINUS = 45
const GLFW_KEY_PERIOD = 46
const GLFW_KEY_SLASH = 47
const GLFW_KEY_0 = 48
const GLFW_KEY_1 = 49
const GLFW_KEY_2 = 50
const GLFW_KEY_3 = 51
const GLFW_KEY_4 = 52
const GLFW_KEY_5 = 53
const GLFW_KEY_6 = 54
const GLFW_KEY_7 = 55
const GLFW_KEY_8 = 56
const GLFW_KEY_9 = 57
const GLFW_KEY_SEMICOLON = 59
const GLFW_KEY_EQUAL = 61
const GLFW_KEY_A = 65
const GLFW_KEY_B = 66
const GLFW_KEY_C = 67
const GLFW_KEY_D = 68
const GLFW_KEY_E = 69
const GLFW_KEY_F = 70
const GLFW_KEY_G = 71
const GLFW_KEY_H = 72
const GLFW_KEY_I = 73
const GLFW_KEY_J = 74
const GLFW_KEY_K = 75
const GLFW_KEY_L = 76
const GLFW_KEY_M = 77
const GLFW_KEY_N = 78
const GLFW_KEY_O = 79
const GLFW_KEY_P = 80
const GLFW_KEY_Q = 81
const GLFW_KEY_R = 82
const GLFW_KEY_S = 83
const GLFW_KEY_T = 84
const GLFW_KEY_U = 85
const GLFW_KEY_V = 86
const GLFW_KEY_W = 87
const GLFW_KEY_X = 88
const GLFW_KEY_Y = 89
const GLFW_KEY_Z = 90
const GLFW_KEY_LEFT_BRACKET = 91
const GLFW_KEY_BACKSLASH = 92
const GLFW_KEY_RIGHT_BRACKET = 93
const GLFW_KEY_GRAVE_ACCENT = 96
const GLFW_KEY_WORLD_1 = 161
const GLFW_KEY_WORLD_2 = 162
const GLFW_KEY_ESCAPE = 256
const GLFW_KEY_ENTER = 257
const GLFW_KEY_TAB = 258
const GLFW_KEY_BACKSPACE = 259
const GLFW_KEY_INSERT = 260
const GLFW_KEY_DELETE = 261
const GLFW_KEY_RIGHT = 262
const GLFW_KEY_LEFT = 263
const GLFW_KEY_DOWN = 264
const GLFW_KEY_UP = 265
const GLFW_KEY_PAGE_UP = 266
const GLFW_KEY_PAGE_DOWN = 267
const GLFW_KEY_HOME = 268
const GLFW_KEY_END = 269
const GLFW_KEY_CAPS_LOCK = 280
const GLFW_KEY_SCROLL_LOCK = 281
const GLFW_KEY_NUM_LOCK = 282
const GLFW_KEY_PRINT_SCREEN = 283
const GLFW_KEY_PAUSE = 284
const GLFW_KEY_F1 = 290
const GLFW_KEY_F2 = 291
const GLFW_KEY_F3 = 292
const GLFW_KEY_F4 = 293
const GLFW_KEY_F5 = 294
const GLFW_KEY_F6 = 295
const GLFW_KEY_F7 = 296
const GLFW_KEY_F8 = 297
const GLFW_KEY_F9 = 298
const GLFW_KEY_F10 = 299
const GLFW_KEY_F11 = 300
const GLFW_KEY_F12 = 301
const GLFW_KEY_F13 = 302
const GLFW_KEY_F14 = 303
const GLFW_KEY_F15 = 304
const GLFW_KEY_F16 = 305
const GLFW_KEY_F17 = 306
const GLFW_KEY_F18 = 307
const GLFW_KEY_F19 = 308
const GLFW_KEY_F20 = 309
const GLFW_KEY_F21 = 310
const GLFW_KEY_F22 = 311
const GLFW_KEY_F23 = 312
const GLFW_KEY_F24 = 313
const GLFW_KEY_F25 = 314
const GLFW_KEY_KP_0 = 320
const GLFW_KEY_KP_1 = 321
const GLFW_KEY_KP_2 = 322
const GLFW_KEY_KP_3 = 323
const GLFW_KEY_KP_4 = 324
const GLFW_KEY_KP_5 = 325
const GLFW_KEY_KP_6 = 326
const GLFW_KEY_KP_7 = 327
const GLFW_KEY_KP_8 = 328
const GLFW_KEY_KP_9 = 329
const GLFW_KEY_KP_DECIMAL = 330
const GLFW_KEY_KP_DIVIDE = 331
const GLFW_KEY_KP_MULTIPLY = 332
const GLFW_KEY_KP_SUBTRACT = 333
const GLFW_KEY_KP_ADD = 334
const GLFW_KEY_KP_ENTER = 335
const GLFW_KEY_KP_EQUAL = 336
const GLFW_KEY_LEFT_SHIFT = 340
const GLFW_KEY_LEFT_CONTROL = 341
const GLFW_KEY_LEFT_ALT = 342
const GLFW_KEY_LEFT_SUPER = 343
const GLFW_KEY_RIGHT_SHIFT = 344
const GLFW_KEY_RIGHT_CONTROL = 345
const GLFW_KEY_RIGHT_ALT = 346
const GLFW_KEY_RIGHT_SUPER = 347
const GLFW_KEY_MENU = 348
const GLFW_KEY_LAST = GLFW_KEY_MENU
const GLFW_MOD_SHIFT = &h0001
const GLFW_MOD_CONTROL = &h0002
const GLFW_MOD_ALT = &h0004
const GLFW_MOD_SUPER = &h0008
const GLFW_MOD_CAPS_LOCK = &h0010
const GLFW_MOD_NUM_LOCK = &h0020
const GLFW_MOUSE_BUTTON_1 = 0
const GLFW_MOUSE_BUTTON_2 = 1
const GLFW_MOUSE_BUTTON_3 = 2
const GLFW_MOUSE_BUTTON_4 = 3
const GLFW_MOUSE_BUTTON_5 = 4
const GLFW_MOUSE_BUTTON_6 = 5
const GLFW_MOUSE_BUTTON_7 = 6
const GLFW_MOUSE_BUTTON_8 = 7
const GLFW_MOUSE_BUTTON_LAST = GLFW_MOUSE_BUTTON_8
const GLFW_MOUSE_BUTTON_LEFT = GLFW_MOUSE_BUTTON_1
const GLFW_MOUSE_BUTTON_RIGHT = GLFW_MOUSE_BUTTON_2
const GLFW_MOUSE_BUTTON_MIDDLE = GLFW_MOUSE_BUTTON_3
const GLFW_JOYSTICK_1 = 0
const GLFW_JOYSTICK_2 = 1
const GLFW_JOYSTICK_3 = 2
const GLFW_JOYSTICK_4 = 3
const GLFW_JOYSTICK_5 = 4
const GLFW_JOYSTICK_6 = 5
const GLFW_JOYSTICK_7 = 6
const GLFW_JOYSTICK_8 = 7
const GLFW_JOYSTICK_9 = 8
const GLFW_JOYSTICK_10 = 9
const GLFW_JOYSTICK_11 = 10
const GLFW_JOYSTICK_12 = 11
const GLFW_JOYSTICK_13 = 12
const GLFW_JOYSTICK_14 = 13
const GLFW_JOYSTICK_15 = 14
const GLFW_JOYSTICK_16 = 15
const GLFW_JOYSTICK_LAST = GLFW_JOYSTICK_16
const GLFW_GAMEPAD_BUTTON_A = 0
const GLFW_GAMEPAD_BUTTON_B = 1
const GLFW_GAMEPAD_BUTTON_X = 2
const GLFW_GAMEPAD_BUTTON_Y = 3
const GLFW_GAMEPAD_BUTTON_LEFT_BUMPER = 4
const GLFW_GAMEPAD_BUTTON_RIGHT_BUMPER = 5
const GLFW_GAMEPAD_BUTTON_BACK = 6
const GLFW_GAMEPAD_BUTTON_START = 7
const GLFW_GAMEPAD_BUTTON_GUIDE = 8
const GLFW_GAMEPAD_BUTTON_LEFT_THUMB = 9
const GLFW_GAMEPAD_BUTTON_RIGHT_THUMB = 10
const GLFW_GAMEPAD_BUTTON_DPAD_UP = 11
const GLFW_GAMEPAD_BUTTON_DPAD_RIGHT = 12
const GLFW_GAMEPAD_BUTTON_DPAD_DOWN = 13
const GLFW_GAMEPAD_BUTTON_DPAD_LEFT = 14
const GLFW_GAMEPAD_BUTTON_LAST = GLFW_GAMEPAD_BUTTON_DPAD_LEFT
const GLFW_GAMEPAD_BUTTON_CROSS = GLFW_GAMEPAD_BUTTON_A
const GLFW_GAMEPAD_BUTTON_CIRCLE = GLFW_GAMEPAD_BUTTON_B
const GLFW_GAMEPAD_BUTTON_SQUARE = GLFW_GAMEPAD_BUTTON_X
const GLFW_GAMEPAD_BUTTON_TRIANGLE = GLFW_GAMEPAD_BUTTON_Y
const GLFW_GAMEPAD_AXIS_LEFT_X = 0
const GLFW_GAMEPAD_AXIS_LEFT_Y = 1
const GLFW_GAMEPAD_AXIS_RIGHT_X = 2
const GLFW_GAMEPAD_AXIS_RIGHT_Y = 3
const GLFW_GAMEPAD_AXIS_LEFT_TRIGGER = 4
const GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER = 5
const GLFW_GAMEPAD_AXIS_LAST = GLFW_GAMEPAD_AXIS_RIGHT_TRIGGER
const GLFW_NO_ERROR = 0
const GLFW_NOT_INITIALIZED = &h00010001
const GLFW_NO_CURRENT_CONTEXT = &h00010002
const GLFW_INVALID_ENUM = &h00010003
const GLFW_INVALID_VALUE = &h00010004
const GLFW_OUT_OF_MEMORY = &h00010005
const GLFW_API_UNAVAILABLE = &h00010006
const GLFW_VERSION_UNAVAILABLE = &h00010007
const GLFW_PLATFORM_ERROR = &h00010008
const GLFW_FORMAT_UNAVAILABLE = &h00010009
const GLFW_NO_WINDOW_CONTEXT = &h0001000A
const GLFW_CURSOR_UNAVAILABLE = &h0001000B
const GLFW_FEATURE_UNAVAILABLE = &h0001000C
const GLFW_FEATURE_UNIMPLEMENTED = &h0001000D
const GLFW_PLATFORM_UNAVAILABLE = &h0001000E
const GLFW_FOCUSED = &h00020001
const GLFW_ICONIFIED = &h00020002
const GLFW_RESIZABLE = &h00020003
const GLFW_VISIBLE = &h00020004
const GLFW_DECORATED = &h00020005
const GLFW_AUTO_ICONIFY = &h00020006
const GLFW_FLOATING = &h00020007
const GLFW_MAXIMIZED = &h00020008
const GLFW_CENTER_CURSOR = &h00020009
const GLFW_TRANSPARENT_FRAMEBUFFER = &h0002000A
const GLFW_HOVERED = &h0002000B
const GLFW_FOCUS_ON_SHOW = &h0002000C
const GLFW_MOUSE_PASSTHROUGH = &h0002000D
const GLFW_POSITION_X = &h0002000E
const GLFW_POSITION_Y = &h0002000F
const GLFW_RED_BITS = &h00021001
const GLFW_GREEN_BITS = &h00021002
const GLFW_BLUE_BITS = &h00021003
const GLFW_ALPHA_BITS = &h00021004
const GLFW_DEPTH_BITS = &h00021005
const GLFW_STENCIL_BITS = &h00021006
const GLFW_ACCUM_RED_BITS = &h00021007
const GLFW_ACCUM_GREEN_BITS = &h00021008
const GLFW_ACCUM_BLUE_BITS = &h00021009
const GLFW_ACCUM_ALPHA_BITS = &h0002100A
const GLFW_AUX_BUFFERS = &h0002100B
const GLFW_STEREO = &h0002100C
const GLFW_SAMPLES = &h0002100D
const GLFW_SRGB_CAPABLE = &h0002100E
const GLFW_REFRESH_RATE = &h0002100F
const GLFW_DOUBLEBUFFER = &h00021010
const GLFW_CLIENT_API = &h00022001
const GLFW_CONTEXT_VERSION_MAJOR = &h00022002
const GLFW_CONTEXT_VERSION_MINOR = &h00022003
const GLFW_CONTEXT_REVISION = &h00022004
const GLFW_CONTEXT_ROBUSTNESS = &h00022005
const GLFW_OPENGL_FORWARD_COMPAT = &h00022006
const GLFW_CONTEXT_DEBUG = &h00022007
const GLFW_OPENGL_DEBUG_CONTEXT = GLFW_CONTEXT_DEBUG
const GLFW_OPENGL_PROFILE = &h00022008
const GLFW_CONTEXT_RELEASE_BEHAVIOR = &h00022009
const GLFW_CONTEXT_NO_ERROR = &h0002200A
const GLFW_CONTEXT_CREATION_API = &h0002200B
const GLFW_SCALE_TO_MONITOR = &h0002200C
const GLFW_SCALE_FRAMEBUFFER = &h0002200D
const GLFW_COCOA_RETINA_FRAMEBUFFER = &h00023001
const GLFW_COCOA_FRAME_NAME = &h00023002
const GLFW_COCOA_GRAPHICS_SWITCHING = &h00023003
const GLFW_X11_CLASS_NAME = &h00024001
const GLFW_X11_INSTANCE_NAME = &h00024002
const GLFW_WIN32_KEYBOARD_MENU = &h00025001
const GLFW_WIN32_SHOWDEFAULT = &h00025002
const GLFW_WAYLAND_APP_ID = &h00026001
const GLFW_NO_API = 0
const GLFW_OPENGL_API = &h00030001
const GLFW_OPENGL_ES_API = &h00030002
const GLFW_NO_ROBUSTNESS = 0
const GLFW_NO_RESET_NOTIFICATION = &h00031001
const GLFW_LOSE_CONTEXT_ON_RESET = &h00031002
const GLFW_OPENGL_ANY_PROFILE = 0
const GLFW_OPENGL_CORE_PROFILE = &h00032001
const GLFW_OPENGL_COMPAT_PROFILE = &h00032002
const GLFW_CURSOR = &h00033001
const GLFW_STICKY_KEYS = &h00033002
const GLFW_STICKY_MOUSE_BUTTONS = &h00033003
const GLFW_LOCK_KEY_MODS = &h00033004
const GLFW_RAW_MOUSE_MOTION = &h00033005
const GLFW_CURSOR_NORMAL = &h00034001
const GLFW_CURSOR_HIDDEN = &h00034002
const GLFW_CURSOR_DISABLED = &h00034003
const GLFW_CURSOR_CAPTURED = &h00034004
const GLFW_ANY_RELEASE_BEHAVIOR = 0
const GLFW_RELEASE_BEHAVIOR_FLUSH = &h00035001
const GLFW_RELEASE_BEHAVIOR_NONE = &h00035002
const GLFW_NATIVE_CONTEXT_API = &h00036001
const GLFW_EGL_CONTEXT_API = &h00036002
const GLFW_OSMESA_CONTEXT_API = &h00036003
const GLFW_ANGLE_PLATFORM_TYPE_NONE = &h00037001
const GLFW_ANGLE_PLATFORM_TYPE_OPENGL = &h00037002
const GLFW_ANGLE_PLATFORM_TYPE_OPENGLES = &h00037003
const GLFW_ANGLE_PLATFORM_TYPE_D3D9 = &h00037004
const GLFW_ANGLE_PLATFORM_TYPE_D3D11 = &h00037005
const GLFW_ANGLE_PLATFORM_TYPE_VULKAN = &h00037007
const GLFW_ANGLE_PLATFORM_TYPE_METAL = &h00037008
const GLFW_WAYLAND_PREFER_LIBDECOR = &h00038001
const GLFW_WAYLAND_DISABLE_LIBDECOR = &h00038002
const GLFW_ANY_POSITION = &h80000000
const GLFW_ARROW_CURSOR = &h00036001
const GLFW_IBEAM_CURSOR = &h00036002
const GLFW_CROSSHAIR_CURSOR = &h00036003
const GLFW_POINTING_HAND_CURSOR = &h00036004
const GLFW_RESIZE_EW_CURSOR = &h00036005
const GLFW_RESIZE_NS_CURSOR = &h00036006
const GLFW_RESIZE_NWSE_CURSOR = &h00036007
const GLFW_RESIZE_NESW_CURSOR = &h00036008
const GLFW_RESIZE_ALL_CURSOR = &h00036009
const GLFW_NOT_ALLOWED_CURSOR = &h0003600A
const GLFW_HRESIZE_CURSOR = GLFW_RESIZE_EW_CURSOR
const GLFW_VRESIZE_CURSOR = GLFW_RESIZE_NS_CURSOR
const GLFW_HAND_CURSOR = GLFW_POINTING_HAND_CURSOR
const GLFW_CONNECTED = &h00040001
const GLFW_DISCONNECTED = &h00040002
const GLFW_JOYSTICK_HAT_BUTTONS = &h00050001
const GLFW_ANGLE_PLATFORM_TYPE = &h00050002
const GLFW_PLATFORM = &h00050003
const GLFW_COCOA_CHDIR_RESOURCES = &h00051001
const GLFW_COCOA_MENUBAR = &h00051002
const GLFW_X11_XCB_VULKAN_SURFACE = &h00052001
const GLFW_WAYLAND_LIBDECOR = &h00053001
const GLFW_ANY_PLATFORM = &h00060000
const GLFW_PLATFORM_WIN32 = &h00060001
const GLFW_PLATFORM_COCOA = &h00060002
const GLFW_PLATFORM_WAYLAND = &h00060003
const GLFW_PLATFORM_X11 = &h00060004
const GLFW_PLATFORM_NULL = &h00060005
const GLFW_DONT_CARE = -1

type GLFWglproc as sub()
type GLFWvkproc as sub()
type GLFWallocatefun as function(byval size as uinteger, byval user as any ptr) as any ptr
type GLFWreallocatefun as function(byval block as any ptr, byval size as uinteger, byval user as any ptr) as any ptr
type GLFWdeallocatefun as sub(byval block as any ptr, byval user as any ptr)
type GLFWerrorfun as sub(byval error_code as long, byval description as const zstring ptr)
type GLFWwindowposfun as sub(byval window_ as GLFWwindow ptr, byval xpos as long, byval ypos as long)
type GLFWwindowsizefun as sub(byval window_ as GLFWwindow ptr, byval width as long, byval height as long)
type GLFWwindowclosefun as sub(byval window_ as GLFWwindow ptr)
type GLFWwindowrefreshfun as sub(byval window_ as GLFWwindow ptr)
type GLFWwindowfocusfun as sub(byval window_ as GLFWwindow ptr, byval focused as long)
type GLFWwindowiconifyfun as sub(byval window_ as GLFWwindow ptr, byval iconified as long)
type GLFWwindowmaximizefun as sub(byval window_ as GLFWwindow ptr, byval maximized as long)
type GLFWframebuffersizefun as sub(byval window_ as GLFWwindow ptr, byval width as long, byval height as long)
type GLFWwindowcontentscalefun as sub(byval window_ as GLFWwindow ptr, byval xscale as single, byval yscale as single)
type GLFWmousebuttonfun as sub(byval window_ as GLFWwindow ptr, byval button as long, byval action as long, byval mods as long)
type GLFWcursorposfun as sub(byval window_ as GLFWwindow ptr, byval xpos as double, byval ypos as double)
type GLFWcursorenterfun as sub(byval window_ as GLFWwindow ptr, byval entered as long)
type GLFWscrollfun as sub(byval window_ as GLFWwindow ptr, byval xoffset as double, byval yoffset as double)
type GLFWkeyfun as sub(byval window_ as GLFWwindow ptr, byval key as long, byval scancode as long, byval action as long, byval mods as long)
type GLFWcharfun as sub(byval window_ as GLFWwindow ptr, byval codepoint as ulong)
type GLFWcharmodsfun as sub(byval window_ as GLFWwindow ptr, byval codepoint as ulong, byval mods as long)
type GLFWdropfun as sub(byval window_ as GLFWwindow ptr, byval path_count as long, byval paths as const zstring ptr ptr)
type GLFWmonitorfun as sub(byval monitor as GLFWmonitor ptr, byval event as long)
type GLFWjoystickfun as sub(byval jid as long, byval event as long)

type GLFWvidmode
	width as long
	height as long
	redBits as long
	greenBits as long
	blueBits as long
	refreshRate as long
end type

type GLFWgammaramp
	red as ushort ptr
	green as ushort ptr
	blue as ushort ptr
	size as ulong
end type

type GLFWimage
	width as long
	height as long
	pixels as ubyte ptr
end type

type GLFWgamepadstate
	buttons(0 to 14) as ubyte
	axes(0 to 5) as single
end type

type GLFWallocator
	allocate as GLFWallocatefun
	reallocate as GLFWreallocatefun
	deallocate as GLFWdeallocatefun
	user as any ptr
end type

declare function glfwInit() as long
declare sub glfwTerminate()
declare sub glfwInitHint(byval hint as long, byval value as long)
declare sub glfwInitAllocator(byval allocator as const GLFWallocator ptr)
declare sub glfwGetVersion(byval major as long ptr, byval minor as long ptr, byval rev as long ptr)
declare function glfwGetVersionString() as const zstring ptr
declare function glfwGetError(byval description as const zstring ptr ptr) as long
declare function glfwSetErrorCallback(byval callback as GLFWerrorfun) as GLFWerrorfun
declare function glfwGetPlatform() as long
declare function glfwPlatformSupported(byval platform as long) as long
declare function glfwGetMonitors(byval count as long ptr) as GLFWmonitor ptr ptr
declare function glfwGetPrimaryMonitor() as GLFWmonitor ptr
declare sub glfwGetMonitorPos(byval monitor as GLFWmonitor ptr, byval xpos as long ptr, byval ypos as long ptr)
declare sub glfwGetMonitorWorkarea(byval monitor as GLFWmonitor ptr, byval xpos as long ptr, byval ypos as long ptr, byval width as long ptr, byval height as long ptr)
declare sub glfwGetMonitorPhysicalSize(byval monitor as GLFWmonitor ptr, byval widthMM as long ptr, byval heightMM as long ptr)
declare sub glfwGetMonitorContentScale(byval monitor as GLFWmonitor ptr, byval xscale as single ptr, byval yscale as single ptr)
declare function glfwGetMonitorName(byval monitor as GLFWmonitor ptr) as const zstring ptr
declare sub glfwSetMonitorUserPointer(byval monitor as GLFWmonitor ptr, byval pointer as any ptr)
declare function glfwGetMonitorUserPointer(byval monitor as GLFWmonitor ptr) as any ptr
declare function glfwSetMonitorCallback(byval callback as GLFWmonitorfun) as GLFWmonitorfun
declare function glfwGetVideoModes(byval monitor as GLFWmonitor ptr, byval count as long ptr) as const GLFWvidmode ptr
declare function glfwGetVideoMode(byval monitor as GLFWmonitor ptr) as const GLFWvidmode ptr
declare sub glfwSetGamma(byval monitor as GLFWmonitor ptr, byval gamma as single)
declare function glfwGetGammaRamp(byval monitor as GLFWmonitor ptr) as const GLFWgammaramp ptr
declare sub glfwSetGammaRamp(byval monitor as GLFWmonitor ptr, byval ramp as const GLFWgammaramp ptr)
declare sub glfwDefaultWindowHints()
declare sub glfwWindowHint(byval hint as long, byval value as long)
declare sub glfwWindowHintString(byval hint as long, byval value as const zstring ptr)
declare function glfwCreateWindow(byval width as long, byval height as long, byval title as const zstring ptr, byval monitor as GLFWmonitor ptr, byval share as GLFWwindow ptr) as GLFWwindow ptr
declare sub glfwDestroyWindow(byval window as GLFWwindow ptr)
declare function glfwWindowShouldClose(byval window as GLFWwindow ptr) as long
declare sub glfwSetWindowShouldClose(byval window as GLFWwindow ptr, byval value as long)
declare function glfwGetWindowTitle(byval window as GLFWwindow ptr) as const zstring ptr
declare sub glfwSetWindowTitle(byval window as GLFWwindow ptr, byval title as const zstring ptr)
declare sub glfwSetWindowIcon(byval window as GLFWwindow ptr, byval count as long, byval images as const GLFWimage ptr)
declare sub glfwGetWindowPos(byval window as GLFWwindow ptr, byval xpos as long ptr, byval ypos as long ptr)
declare sub glfwSetWindowPos(byval window as GLFWwindow ptr, byval xpos as long, byval ypos as long)
declare sub glfwGetWindowSize(byval window as GLFWwindow ptr, byval width as long ptr, byval height as long ptr)
declare sub glfwSetWindowSizeLimits(byval window as GLFWwindow ptr, byval minwidth as long, byval minheight as long, byval maxwidth as long, byval maxheight as long)
declare sub glfwSetWindowAspectRatio(byval window as GLFWwindow ptr, byval numer as long, byval denom as long)
declare sub glfwSetWindowSize(byval window as GLFWwindow ptr, byval width as long, byval height as long)
declare sub glfwGetFramebufferSize(byval window as GLFWwindow ptr, byval width as long ptr, byval height as long ptr)
declare sub glfwGetWindowFrameSize(byval window as GLFWwindow ptr, byval left as long ptr, byval top as long ptr, byval right as long ptr, byval bottom as long ptr)
declare sub glfwGetWindowContentScale(byval window as GLFWwindow ptr, byval xscale as single ptr, byval yscale as single ptr)
declare function glfwGetWindowOpacity(byval window as GLFWwindow ptr) as single
declare sub glfwSetWindowOpacity(byval window as GLFWwindow ptr, byval opacity as single)
declare sub glfwIconifyWindow(byval window as GLFWwindow ptr)
declare sub glfwRestoreWindow(byval window as GLFWwindow ptr)
declare sub glfwMaximizeWindow(byval window as GLFWwindow ptr)
declare sub glfwShowWindow(byval window as GLFWwindow ptr)
declare sub glfwHideWindow(byval window as GLFWwindow ptr)
declare sub glfwFocusWindow(byval window as GLFWwindow ptr)
declare sub glfwRequestWindowAttention(byval window as GLFWwindow ptr)
declare function glfwGetWindowMonitor(byval window as GLFWwindow ptr) as GLFWmonitor ptr
declare sub glfwSetWindowMonitor(byval window as GLFWwindow ptr, byval monitor as GLFWmonitor ptr, byval xpos as long, byval ypos as long, byval width as long, byval height as long, byval refreshRate as long)
declare function glfwGetWindowAttrib(byval window as GLFWwindow ptr, byval attrib as long) as long
declare sub glfwSetWindowAttrib(byval window as GLFWwindow ptr, byval attrib as long, byval value as long)
declare sub glfwSetWindowUserPointer(byval window as GLFWwindow ptr, byval pointer as any ptr)
declare function glfwGetWindowUserPointer(byval window as GLFWwindow ptr) as any ptr
declare function glfwSetWindowPosCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowposfun) as GLFWwindowposfun
declare function glfwSetWindowSizeCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowsizefun) as GLFWwindowsizefun
declare function glfwSetWindowCloseCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowclosefun) as GLFWwindowclosefun
declare function glfwSetWindowRefreshCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowrefreshfun) as GLFWwindowrefreshfun
declare function glfwSetWindowFocusCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowfocusfun) as GLFWwindowfocusfun
declare function glfwSetWindowIconifyCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowiconifyfun) as GLFWwindowiconifyfun
declare function glfwSetWindowMaximizeCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowmaximizefun) as GLFWwindowmaximizefun
declare function glfwSetFramebufferSizeCallback(byval window as GLFWwindow ptr, byval callback as GLFWframebuffersizefun) as GLFWframebuffersizefun
declare function glfwSetWindowContentScaleCallback(byval window as GLFWwindow ptr, byval callback as GLFWwindowcontentscalefun) as GLFWwindowcontentscalefun
declare sub glfwPollEvents()
declare sub glfwWaitEvents()
declare sub glfwWaitEventsTimeout(byval timeout as double)
declare sub glfwPostEmptyEvent()
declare function glfwGetInputMode(byval window as GLFWwindow ptr, byval mode as long) as long
declare sub glfwSetInputMode(byval window as GLFWwindow ptr, byval mode as long, byval value as long)
declare function glfwRawMouseMotionSupported() as long
declare function glfwGetKeyName(byval key as long, byval scancode as long) as const zstring ptr
declare function glfwGetKeyScancode(byval key as long) as long
declare function glfwGetKey(byval window as GLFWwindow ptr, byval key as long) as long
declare function glfwGetMouseButton(byval window as GLFWwindow ptr, byval button as long) as long
declare sub glfwGetCursorPos(byval window as GLFWwindow ptr, byval xpos as double ptr, byval ypos as double ptr)
declare sub glfwSetCursorPos(byval window as GLFWwindow ptr, byval xpos as double, byval ypos as double)
declare function glfwCreateCursor(byval image as const GLFWimage ptr, byval xhot as long, byval yhot as long) as GLFWcursor ptr
declare function glfwCreateStandardCursor(byval shape as long) as GLFWcursor ptr
declare sub glfwDestroyCursor(byval cursor as GLFWcursor ptr)
declare sub glfwSetCursor(byval window as GLFWwindow ptr, byval cursor as GLFWcursor ptr)
declare function glfwSetKeyCallback(byval window as GLFWwindow ptr, byval callback as GLFWkeyfun) as GLFWkeyfun
declare function glfwSetCharCallback(byval window as GLFWwindow ptr, byval callback as GLFWcharfun) as GLFWcharfun
declare function glfwSetCharModsCallback(byval window as GLFWwindow ptr, byval callback as GLFWcharmodsfun) as GLFWcharmodsfun
declare function glfwSetMouseButtonCallback(byval window as GLFWwindow ptr, byval callback as GLFWmousebuttonfun) as GLFWmousebuttonfun
declare function glfwSetCursorPosCallback(byval window as GLFWwindow ptr, byval callback as GLFWcursorposfun) as GLFWcursorposfun
declare function glfwSetCursorEnterCallback(byval window as GLFWwindow ptr, byval callback as GLFWcursorenterfun) as GLFWcursorenterfun
declare function glfwSetScrollCallback(byval window as GLFWwindow ptr, byval callback as GLFWscrollfun) as GLFWscrollfun
declare function glfwSetDropCallback(byval window as GLFWwindow ptr, byval callback as GLFWdropfun) as GLFWdropfun
declare function glfwJoystickPresent(byval jid as long) as long
declare function glfwGetJoystickAxes(byval jid as long, byval count as long ptr) as const single ptr
declare function glfwGetJoystickButtons(byval jid as long, byval count as long ptr) as const ubyte ptr
declare function glfwGetJoystickHats(byval jid as long, byval count as long ptr) as const ubyte ptr
declare function glfwGetJoystickName(byval jid as long) as const zstring ptr
declare function glfwGetJoystickGUID(byval jid as long) as const zstring ptr
declare sub glfwSetJoystickUserPointer(byval jid as long, byval pointer as any ptr)
declare function glfwGetJoystickUserPointer(byval jid as long) as any ptr
declare function glfwJoystickIsGamepad(byval jid as long) as long
declare function glfwSetJoystickCallback(byval callback as GLFWjoystickfun) as GLFWjoystickfun
declare function glfwUpdateGamepadMappings(byval string as const zstring ptr) as long
declare function glfwGetGamepadName(byval jid as long) as const zstring ptr
declare function glfwGetGamepadState(byval jid as long, byval state as GLFWgamepadstate ptr) as long
declare sub glfwSetClipboardString(byval window as GLFWwindow ptr, byval string as const zstring ptr)
declare function glfwGetClipboardString(byval window as GLFWwindow ptr) as const zstring ptr
declare function glfwGetTime() as double
declare sub glfwSetTime(byval time as double)
declare function glfwGetTimerValue() as ulongint
declare function glfwGetTimerFrequency() as ulongint
declare sub glfwMakeContextCurrent(byval window as GLFWwindow ptr)
declare function glfwGetCurrentContext() as GLFWwindow ptr
declare sub glfwSwapBuffers(byval window as GLFWwindow ptr)
declare sub glfwSwapInterval(byval interval as long)
declare function glfwExtensionSupported(byval extension as const zstring ptr) as long
declare function glfwGetProcAddress(byval procname as const zstring ptr) as GLFWglproc
declare function glfwVulkanSupported() as long
declare function glfwGetRequiredInstanceExtensions(byval count as ulong ptr) as const zstring ptr ptr

#define GLAPIENTRY APIENTRY
#define GLFW_GLAPIENTRY_DEFINED

end extern
