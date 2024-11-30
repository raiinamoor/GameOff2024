extends Node


@export var starting_track: NodePath
@export var transition_duration: float = 1.5
var min_volume = ProjectSettings.get_setting("audio/buses/channel_disable_threshold_db")
var prev_layer: AudioStreamPlayer
@onready var curr_layer: AudioStreamPlayer = $TitleTheme:
	set(value):
		prev_layer = curr_layer
		transition(curr_layer, value)
		curr_layer = value


func start():
	fade($HouseBaseLayer, true)
	await fade($TitleTheme, false)
	$HouseBaseLayer.play()
	$HouseMitzieLayer.play()
	$HouseCainLayer.play()
	$HouseAuntJLayer.play()
	$PinboardLayer.play()
	curr_layer = $HouseMitzieLayer


func play_pinboard_music(play: bool):
	if play:
		curr_layer = $PinboardLayer
	else:
		print(curr_layer.name, prev_layer.name)
		curr_layer = prev_layer


func fade(what: AudioStreamPlayer, fade_in = true):
	var final_val = 0 if fade_in else min_volume 
	var volume_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	volume_tween.tween_property(what, "volume_db", final_val, transition_duration)
	await volume_tween.finished


func transition(from:AudioStreamPlayer, to: AudioStreamPlayer):
	var volume_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	volume_tween.tween_property(from, "volume_db", min_volume, transition_duration)
	volume_tween.tween_property(to, "volume_db", 0, transition_duration)
	await volume_tween.finished
