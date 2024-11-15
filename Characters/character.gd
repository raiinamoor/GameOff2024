extends Area3D


@export var timeline_name: String = ""

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("start_conversation"):
		print("Conversation started")
		Dialogic.start(timeline_name)


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
