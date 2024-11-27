extends Node


@export var starting_track: NodePath
@export var transition_duration: float = 3
var min_volume = ProjectSettings.get_setting("audio/buses/channel_disable_threshold_db")

@onready var curr_track: AudioStreamPlayer = $TitleTheme:
	set(value):
		transition(value)


#func _ready() -> void:
	#play()
#
#
#func play(what: AudioStreamPlayer):
	#for child in get_children():
		#child.volume_db = -60
	#what.volume_db = 0


func transition(to: AudioStreamPlayer):
	var volume_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	volume_tween.tween_property(curr_track, "volume_db", min_volume, transition_duration)
	volume_tween.tween_property(to, "volume_db", 0, transition_duration)
	await volume_tween.finished
	curr_track = to
