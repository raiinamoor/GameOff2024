extends Control


@export var clusters: Array[Dictionary]
var queued_notes: Array[Button] = []
@onready var notes: Array[Node] = get_tree().get_nodes_in_group("notes")
@onready var cluster_flags: Array[bool] = []

func _ready() -> void:
	for i in clusters.size():
		cluster_flags.append(false)
	for note in get_tree().get_nodes_in_group("notes"):
		note.connection_changed.connect(_on_connection_changed)
	
	Dialogic.signal_event.connect(queue_note)
	$"../../UILayer/Screen/OpenPinboardButton".pressed.connect(toggle_board)


func toggle_board():
	if not $"..".visible:
		show_board()
	else:
		hide_board()


func show_board() -> void:
	$"..".visible = true
	var t: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	t.tween_property(self, "position:y", 0, 1)
	await t.finished
	
	update_board()


func hide_board():
	#camera.zoom = Vector2(1, 1)
	var t: Tween = create_tween()
	t.tween_property(camera_2d, "zoom", Vector2(0.5, 0.5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	t.tween_property(self, "position:y", -$BG.size.y, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await t.finished
	
	$"..".visible = false


func update_board():
	for note in queued_notes:
		note.reveal()
	queued_notes.clear()


func queue_note(dialogic_arg: String):
	if dialogic_arg.contains("_get"):
		var idx: String = dialogic_arg.replace("_get", "")
		queued_notes.append( get_node(idx) )


func _on_connection_changed(n: Button) -> void:
	for i in clusters.size():
		var connections_to_lock: Array[Connection] = []
		if cluster_flags[i]:
			return
		# checking clusters for completion
		var cluster = clusters[i]
		var cluster_complete: bool = true
		for root_node_path in cluster:
			var root_node: Button = get_node(root_node_path)
			var end_node_dicts: Dictionary = cluster[root_node_path]
			for end_node_path in end_node_dicts:
				var end_node: Button = get_node(end_node_path)
				var connection_type: int = end_node_dicts[end_node_path]
				if not (root_node.connections.has(end_node) and root_node.connections.get(end_node, null).connection_type == connection_type):
					cluster_complete = false
				else:
					connections_to_lock.append(root_node.connections.get(end_node, null))
		
		if cluster_complete and not cluster_flags[i]:
			# marking the cluster as complete
			print("Cluster {name} complete!".format({"name": cluster}))
			cluster_flags[i] = true
			
			# doing stuff for each note in completed cluster
			for note_path in cluster:
				# TODO move a note to a pre-defined place on the board when it is complete?
				var note: Button = get_node(note_path)
				if not clusters.any(func(c: Dictionary): return c.has(note.get_path())):
					note.display_as_completed()
			for connection: Connection in connections_to_lock:
				connection.lock()
