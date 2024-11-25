class_name Connection
extends Area2D


signal connection_removed(connection: Connection)

@export_enum("NONE", "TYPE1", "TYPE2", "TYPE3") var connection_type: int
var end_node: Button = null

@onready var root_node: Button = get_parent()
@onready var line_2d: Line2D = $Line2D
@onready var collider: CollisionShape2D = $Collider


func _ready() -> void:
	line_2d.points = [Vector2.ZERO, Vector2.ZERO]


func _process(delta: float) -> void:
	# calculate end position of Line2D
	if end_node == null:
		line_2d.points[-1] = get_local_mouse_position()
	else:
		var end_position: Vector2 = end_node.global_position + end_node.get_rect().size / 2
		# TODO make it so that the line connects to the edge of the note
		#var position_on_edge: Vector2 = (end_position - root_node.global_position).clamp(-end_node.get_rect().size / 2, end_node.get_rect().size / 2)
		#line_2d.points[-1] = to_local( end_position - position_on_edge )
		line_2d.points[-1] = to_local( end_position )
	
	#position CollisionShape2D in the middle of the line and rotate it
	collider.position = lerp(line_2d.points[0], line_2d.points[1], 0.5)
	collider.shape.size.x = (line_2d.points[0] - line_2d.points[1]).length()
	collider.rotation = line_2d.points[0].angle_to_point(line_2d.points[1])


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("remove_connection"):
		remove_connection()


func connect_to(target: Button) -> void:
	end_node = target
	root_node.connections[target] = self
	collider.disabled = false
	connection_removed.connect(root_node.remove_connection_from_list)
	print("Connections from {name}: {cons}".format({"name": root_node.name, "cons": root_node.connections}))


func remove_connection() -> void:
	collider.disabled = true
	var move_back_tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	move_back_tween.tween_property(line_2d, "points", PackedVector2Array([line_2d.points[0], line_2d.points[0]]), 1) 
	
	await move_back_tween.finished
	connection_removed.emit(self)
	queue_free()


func lock() -> void:
	collider.disabled = true
