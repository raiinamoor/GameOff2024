class_name Connection
extends Control


signal connection_removed(connection: Connection)

@export_enum("NONE", "TYPE1", "TYPE2", "TYPE3") var connection_type: int
var end_node: Button = null

@onready var root_node: Button = get_parent()
@onready var line_2d: Line2D = $Line2D
@onready var button: Button = $Button


func _ready() -> void:
	line_2d.points = [Vector2.ZERO, Vector2.ZERO]


func _process(delta: float) -> void:
	# calculate end position of Line2D
	if end_node == null:
		line_2d.points[-1] = get_local_mouse_position() * 0.99
	else:
		var end_position: Vector2 = end_node.global_position + end_node.get_rect().size / 2
		line_2d.points[-1] = end_position - global_position #+ diff
	
	button.size.x = (line_2d.points[0] - line_2d.points[1]).length()
	button.rotation = line_2d.points[0].angle_to_point(line_2d.points[1])


func connect_to(target: Button) -> void:
	end_node = target
	root_node.connections[target] = self
	button.disabled = false
	connection_removed.connect(root_node.remove_connection_from_list)
	print("Connections from {name}: {cons}".format({"name": root_node.name, "cons": root_node.connections}))


func remove_connection() -> void:
	var move_back_tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	move_back_tween.tween_property(line_2d, "points", PackedVector2Array([line_2d.points[0], line_2d.points[0]]), 1) 
	
	await move_back_tween.finished
	connection_removed.emit(self)
	queue_free()


func lock() -> void:
	button.disabled = true
