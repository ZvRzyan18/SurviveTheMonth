extends Node

signal player_rotate();
var player_position : Vector3 = Vector3.ZERO;
var player_rotation : Vector3 = Vector3.ZERO;
var player_moving : bool = false;

var player_money : float = 18000.0;
var player_money_savings : float = 0.0;
var current_day : int = 1;

#0 = house
#1 = bedroom
var map_id : int = 0;
signal change_map(id : int, new_positon : Vector3, new_rotation : Vector3, path : String);

const LOCATION_HOUSE : int = 0
const LOCATION_BEDROOM : int = 1

func _ready() -> void:
	player_rotate.emit();
	player_position = Vector3.ZERO;
	player_rotation = Vector3.ZERO;
	player_moving = false;
	change_map.connect(on_change_map);


func on_change_map(id : int, new_positon : Vector3, new_rotation : Vector3, _path : String):
	map_id = id;
	player_position = new_positon;
	player_rotation = new_rotation;
