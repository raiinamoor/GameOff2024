extends Node3D


const ARROW_SHAPE = preload("res://UI/Arrow.png")
const GRABBING_HAND = preload("res://UI/Grabbing hand.png")
const OPEN_HAND = preload("res://UI/Open hand.png")
const POINTING_HAND = preload("res://UI/Pointing hand.png")
const BUBBLE_SHAPE = preload("res://UI/Speech bubble.png")


func _ready() -> void:
	Input.set_custom_mouse_cursor(ARROW_SHAPE, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(GRABBING_HAND, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(OPEN_HAND, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(POINTING_HAND, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(BUBBLE_SHAPE, Input.CURSOR_HELP)
