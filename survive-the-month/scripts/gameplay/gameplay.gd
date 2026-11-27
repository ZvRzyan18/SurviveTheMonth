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
	_init_ui();
	
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


var open_map : Button = null;
var open_quest : Button = null;
var quest_panel : Panel = null;
var close_quest : Button = null;

var new_day_panel : Panel = null;
var close_new_day : Button = null;
var new_day_display : Label = null;
signal on_new_day(day : int);

var evaluation_panel : Panel = null;
var close_evaluation : Button = null;
signal on_evaulation();

var open_settings : Button = null;

var close_random_situation1 : Button = null;
var close_savings : Button = null;
var open_costumize : Button = null;

func _init_ui():
	open_map = self.find_child("open_map");
	open_map.pressed.connect(func():
		self.get_tree().change_scene_to_file("res://scenes/GameplayMap.tscn");
	)
	
	open_quest = self.find_child("open_quest");
	quest_panel = self.find_child("quest_panel");
	open_quest.pressed.connect(func():
		quest_panel.visible = true;
	)
	close_quest = self.find_child("close_quest");
	close_quest.pressed.connect(func():
		quest_panel.visible = false;
	)
	
	new_day_panel = self.find_child("new_day_panel");
	close_new_day = self.find_child("close_new_day");
	close_new_day.pressed.connect(func():
		new_day_panel.visible = false;
	);
	new_day_display = self.find_child("new_day_display");
	on_new_day.connect(func(day : int):
		new_day_display.text = "Day : " + str(day);
		new_day_panel.visible = true;
	);
	
	evaluation_panel = self.find_child("evaluation_panel");
	close_evaluation = self.find_child("close_evaluation");
	close_evaluation.pressed.connect(func():
		evaluation_panel.visible = false;
	);
	on_evaulation.connect(func():
		evaluation_panel.visible = true;
	);
	
	open_settings = self.find_child("open_settings");
	open_settings.pressed.connect(func():
		self.find_child("Settings").visible = true;
	);
	
	close_random_situation1 = self.find_child("close_random_situation1");
	close_random_situation1.pressed.connect(func():
		self.find_child("Random_situation1").visible = false;
	);
	
	close_savings = self.find_child("close_savings");
	close_savings.pressed.connect(func():
		self.find_child("savings_panel").visible = false;
	);
	
	open_costumize = self.find_child("open_costumize");
	open_costumize.pressed.connect(func():
		self.find_child("AvatarCostumize").visible = true;
	);
