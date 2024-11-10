extends Control


@export var clusters: Array[Dictionary]
@onready var notes: Array[Node] = get_tree().get_nodes_in_group("notes")
@onready var cluster_flags: Array[bool] = []

func _ready() -> void:
	for i in clusters.size():
		cluster_flags.append(false)
	for note in get_tree().get_nodes_in_group("notes"):
		note.connection_changed.connect(_on_connection_changed)


func _process(delta: float) -> void:
	pass


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
			
			for connection: Connection in connections_to_lock:
				connection.lock()
