extends Node


var min_volume = ProjectSettings.get_setting("audio/buses/channel_disable_threshold_db")

@export var starting_track: NodePath
@export var transition_duration: float = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		transition($"1", $"2")
	if event.is_action_pressed("ui_up"):
		transition($"2", $"1")


func transition(from: AudioStreamPlayer, to: AudioStreamPlayer):
	var volume_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	volume_tween.tween_property(from, "volume_db", min_volume, transition_duration)
	volume_tween.tween_property(to, "volume_db", 0, transition_duration)
