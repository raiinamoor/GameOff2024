extends Control


@export var clusters: Array[Dictionary]
@onready var notes: Array[Node] = get_tree().get_nodes_in_group("notes")

func _ready() -> void:
	for note in get_tree().get_nodes_in_group("notes"):
		note.connection_changed.connect(_on_connection_changed)


func _process(delta: float) -> void:
	pass


func _on_connection_changed(note: Button) -> void:
	for cluster in clusters:
		#if not note in cluster:
			#continue
		
		var cluster_complete: bool = true
		for root_node_path in cluster:
			var root_node: Button = get_node(root_node_path)
			var end_node_dicts: Dictionary = cluster[root_node_path]
			for end_node_path in end_node_dicts:
				var end_node = get_node(end_node_path)
				var connection_type = end_node_dicts[end_node_path]
				if not (root_node.connections.has(end_node) and root_node.connections.get(end_node, null).connection_type == connection_type):
					cluster_complete = false
		
		if cluster_complete:
			print("Cluster {name} complete!".format({"name": cluster}))

	#for cluster in clusters.values():
		#var cluster_complete := true
		#for root_note_path in cluster:
			#var root_node: Button = get_node(root_note_path)
			#var end_node_paths: Array[Dictionary] = cluster[root_note_path]
			#
			#for end_node_path in end_node_paths:
				#var end_node = get_node(end_node_path)
				#if not (root_node.connections.has(end_node) and root_node.connections.get(end_node, null) ): # TODO add connection type 
					#cluster_complete = false
	#
		#if cluster_complete:
			#print("Cluster {name} complete!".format({"name": cluster}))
	pass
