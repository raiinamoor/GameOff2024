extends Node3D


const ARROW_SHAPE = preload("res://UI/Arrow.png")
const GRABBING_HAND = preload("res://UI/Grabbing hand.png")
const OPEN_HAND = preload("res://UI/Open hand.png")
const POINTING_HAND = preload("res://UI/Pointing hand.png")
const BUBBLE_SHAPE = preload("res://UI/Speech bubble.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(ARROW_SHAPE, Input.CURSOR_ARROW, Vector2(16, 3))
	Input.set_custom_mouse_cursor(GRABBING_HAND, Input.CURSOR_DRAG, Vector2(32, 32))
	Input.set_custom_mouse_cursor(OPEN_HAND, Input.CURSOR_CAN_DROP, Vector2(32, 32))
	Input.set_custom_mouse_cursor(POINTING_HAND, Input.CURSOR_POINTING_HAND, Vector2(15, 5))
	Input.set_custom_mouse_cursor(BUBBLE_SHAPE, Input.CURSOR_HELP, Vector2(32, 32)) 
