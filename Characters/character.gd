extends Area3D


@export var timeline_name: String = ""
static var mitzie_style: DialogicStyle = load("res://Characters/Dialogue/mitzie_dialogue_style.tres").prepare()
static var cain_style: DialogicStyle = load("res://Characters/Dialogue/cain_dialogue_style.tres").prepare()
static var aunt_j_style: DialogicStyle = load("res://Characters/Dialogue/aunt_j_dialogue_style.tres").prepare()
var timeline

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	timeline = Dialogic.preload_timeline("res://Characters/Dialogue/Timelines/" + timeline_name + ".dtl")


func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("start_conversation"):
		print("Conversation started")
		var dialogic_scn = Dialogic.start(timeline)
		var screen = get_node("/root/Main/UILayer/Screen")
		await dialogic_scn.child_entered_tree
		dialogic_scn.reparent.call_deferred(screen)


func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_HELP)


func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
