extends Node3D

var cain_unlocked: bool = false
var aunt_j_unlocked: bool = true
@onready var mitzie_room: Node3D = $MitzieRoom
@onready var cain_room: Node3D = $CainRoom
@onready var aunt_j_room: Node3D = $AuntJRoom
@onready var rooms: Dictionary = {
	"mitzie": mitzie_room,
	"cain": cain_room,
	"aunt_j": aunt_j_room
}
# TODO make only mitzie's room available at start
@onready var available_rooms: Array[Node3D] = [mitzie_room]
@onready var curr_room_idx: int = 0:
	set(value):
		if value < 0:
			value = available_rooms.size() - 1
		value %= available_rooms.size()
		$"../MusicManager".curr_layer = $"../MusicManager/HouseMitzieLayer" if value == 0 \
				else $"../MusicManager/HouseCainLayer" if value == 1 \
				else $"../MusicManager/HouseAuntJLayer" if value == 2 \
				else $"../MusicManager/PinboardLayer"
		await %TransitionRect.transition(true, 0.5)
		available_rooms[value].set_camera_active()
		available_rooms[curr_room_idx].visible = false
		available_rooms[value].visible = true
		await %TransitionRect.transition(false, 0.5)
		curr_room_idx = value


func _ready() -> void:
	Dialogic.signal_event.connect(unlock_room)


func move_right():
	curr_room_idx += 1


func move_left():
	curr_room_idx -= 1


func unlock_room(arg_str: String):
	if arg_str.contains("unlock_"):
		var name: String = arg_str.replace("unlock_", "")
		available_rooms.append(rooms[name])
		$"../UILayer/Screen/MoveLeftButton".visible = true
		$"../UILayer/Screen/MoveRightButton".visible = true
