extends Button


enum { 
	CURSOR_DEFAULT,
	CURSOR_CONNECTING
 }

signal connection_changed(note: Button)

@export var connection_scn: PackedScene
var connections: Dictionary = {}
var is_picked: bool = false
var offset_from_mouse: Vector2 = Vector2.ZERO
static var cursor_state = CURSOR_DEFAULT
static var curr_connection: Control

@onready var button_panel: Control = $ButtonPanel


func _process(delta: float) -> void:
	if is_picked:
		position = get_global_mouse_position() + offset_from_mouse


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel_connection") and curr_connection != null:
		cancel_connection()


func reveal():
	visible = true
	modulate.a = 0
	scale = Vector2(3, 3)
	rotation = deg_to_rad(randf_range(-45, 45))
	var reveal_anim: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	reveal_anim.set_parallel()
	reveal_anim.tween_property(self, "modulate:a", 1, 1.5)
	reveal_anim.tween_property(self, "scale", Vector2(1, 1), 1.5)
	reveal_anim.tween_property(self, "rotation", 0,  1.5)


func init_connection(scene_path: String) -> void:
	if not cursor_state == CURSOR_DEFAULT:
		return
	
	var scene: PackedScene = load(scene_path)
	var connection := scene.instantiate()
	connection.position = get_rect().get_center() - position
	add_child(connection)
	
	curr_connection = connection
	cursor_state = CURSOR_CONNECTING


func complete_connection() -> void:
	# TODO break this if statement down maybe?
	if cursor_state == CURSOR_CONNECTING \
			and curr_connection.get_parent() != self \
			and curr_connection.get_parent().connections.get(self) == null \
			and connections.get(curr_connection.get_parent()) == null:
		curr_connection.connect_to(self)
		curr_connection.get_parent().connection_changed.emit(curr_connection.get_parent())
		curr_connection = null
		cursor_state = CURSOR_DEFAULT


func cancel_connection() -> void:
	curr_connection.queue_free()
	curr_connection = null
	cursor_state = CURSOR_DEFAULT


func remove_connection_from_list(connection: Connection) -> void:
	connections.erase(connections.find_key(connection))


func display_as_completed() -> void:
	# TODO change note's appearance when it is complete
	# TODO also add some indicator when it is NOT complete
	pass


func pick_up() -> void:
	hide_buttons()
	var t: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	t.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	is_picked = true
	offset_from_mouse = position - get_global_mouse_position()
	mouse_default_cursor_shape = CursorShape.CURSOR_DRAG


func put_down() -> void:
	var t: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	t.tween_property(self, "scale", Vector2(1, 1), 0.3)
	is_picked = false
	mouse_default_cursor_shape = CursorShape.CURSOR_CAN_DROP


func show_buttons() -> void:
	if is_picked:
		return
	
	#$AnimationPlayer.play("show_connection_buttons")
	button_panel.visible = true
	var t: Tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	t.set_parallel()
	t.tween_property(button_panel, "position:y", -size.y / 5, 0.5)


func hide_buttons() -> void:
	var t: Tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	t.set_parallel()
	t.tween_property(button_panel, "position:y", 30, 0.5)
