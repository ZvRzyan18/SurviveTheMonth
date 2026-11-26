extends Control


var money_display : Label = null;
var day_display : Label = null;

func on_change_view(_id: int,_new_position: Vector3,_new_rotation: Vector3, path: String):
	var tmp_parent: Node = self.find_child("SubViewport")
	var tmp_node : Node = tmp_parent.get_node_or_null("view_3d")
	if tmp_node != null:
		tmp_parent.remove_child(tmp_node)
		
		
	var packed_scene := ResourceLoader.load(path) as PackedScene
	if packed_scene == null:
		push_error("Failed to load scene: " + path)
		return
	var new_scene: Node = packed_scene.instantiate()
	new_scene.name = "view_3d"
	tmp_parent.add_child(new_scene)
	tmp_node.queue_free()
	
func _ready() -> void:
	money_display = self.find_child("money_display");
	day_display = self.find_child("day_display");
	
	GlobalState.change_map.connect(on_change_view);
	match GlobalState.map_id:
		GlobalState.LOCATION_HOUSE:
			GlobalState.change_map.emit(GlobalState.map_id, GlobalState.player_position, GlobalState.player_rotation, "res://scenes/house/HouseView.tscn");
		GlobalState.LOCATION_BEDROOM:
			GlobalState.change_map.emit(GlobalState.map_id, GlobalState.player_position, GlobalState.player_rotation, "res://scenes/house/BedroomView.tscn");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	money_display.text = "Money : " + str(GlobalState.player_money);
	day_display.text = "Day : " + str(GlobalState.current_day);
