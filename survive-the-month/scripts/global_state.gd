extends Node

signal player_rotate();
var player_position : Vector3 = Vector3.ZERO;
var player_rotation : Vector3 = Vector3.ZERO;
var player_moving : bool = false;

var player_money : float = 18000.0;
var current_day : int = 1;

func _ready() -> void:
	player_rotate.emit();
	player_position = Vector3.ZERO;
	player_rotation = Vector3.ZERO;
	player_moving = false;
