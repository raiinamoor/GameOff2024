extends Camera3D


@export var horizontal_limit_deg: int = 90
@export var vertical_limit_deg: int = 90
@export var lerp_coefficient: float = 5

var target_rotation: Vector3 = Vector3.ZERO

@onready var viewport: Viewport = get_viewport() 
@onready var viewport_center: Vector2:
	get: return viewport.get_visible_rect().get_center()
@onready var initial_rotation = rotation_degrees


func _process(delta: float) -> void:
	var centered_mouse_pos = (viewport.get_mouse_position() - viewport_center)
	centered_mouse_pos = centered_mouse_pos.clamp(-viewport_center, viewport_center)
	target_rotation.y = initial_rotation.y - lerp(0, horizontal_limit_deg, centered_mouse_pos.x / viewport_center.x)
	target_rotation.x = initial_rotation.x - lerp(0, vertical_limit_deg, centered_mouse_pos.y / viewport_center.y)
	
	rotation_degrees = lerp(rotation_degrees, target_rotation, lerp_coefficient * delta)
	
