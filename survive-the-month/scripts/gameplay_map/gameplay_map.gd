extends Control


var place_name : Panel = null;
var place_text : Label = null;

var store_area : Node = null;
var house_area : Node = null;
var city_area : Node = null;
var park_area : Node = null;

var money_display : Label = null;
var day_display : Label = null;

func _ready() -> void:
	place_name = self.find_child("place_name");
	place_text = self.find_child("place_text");
	
	store_area = self.find_child("store_area");
	house_area = self.find_child("house_area");
	city_area = self.find_child("city_area");
	park_area = self.find_child("park_area");
	
	money_display = self.find_child("money_display");
	day_display = self.find_child("day_display");
	
	_init_ui();
	
func _input(event: InputEvent) :
	if event is InputEventMouse :
		var mouse_event : InputEventMouse = event as InputEventMouse;
		if house_area.get_global_rect().has_point(mouse_event.global_position) and mouse_event.is_pressed() :
			close_map.pressed.emit()
		elif store_area.get_global_rect().has_point(mouse_event.global_position) and mouse_event.is_pressed() :
			store_panel.visible = true;
		elif city_area.get_global_rect().has_point(mouse_event.global_position) and mouse_event.is_pressed() :
			city_panel.visible = true;
		elif park_area.get_global_rect().has_point(mouse_event.global_position) and mouse_event.is_pressed() :
			park_panel.visible = true;

func _process(_delta: float) -> void:
	money_display.text = "Money : " + str(GlobalState.player_money);
	day_display.text = "Day : " + str(GlobalState.current_day);
	var pos : Vector2 = self.get_global_mouse_position();
	if store_area.get_global_rect().has_point(pos):
		place_name.global_position = pos;
		place_text.text = "Store";
		place_name.visible = true;
	elif house_area.get_global_rect().has_point(pos):
		place_name.global_position = pos;
		place_text.text = "House";
		place_name.visible = true;
	elif city_area.get_global_rect().has_point(pos):
		place_name.global_position = pos;
		place_text.text = "City";
		place_name.visible = true;
	elif park_area.get_global_rect().has_point(pos):
		place_name.global_position = pos;
		place_text.text = "Park";
		place_name.visible = true;
	else :
		place_name.visible = false;

var close_map : Button = null;
var store_panel : Panel = null;
var close_store : Button = null;

var city_panel : Panel = null;
var close_city : Button = null;

var park_panel : Panel = null;
var close_park : Button = null;


func _init_ui():
	close_map = self.find_child("close_map");
	close_map.pressed.connect(func():
		self.get_tree().change_scene_to_file("res://scenes/Gameplay.tscn");
	);
	
	store_panel = self.find_child("store_panel");
	close_store = self.find_child("close_store");
	close_store.pressed.connect(func():
		store_panel.visible = false;
	);
	
	city_panel = self.find_child("city_panel");
	close_city = self.find_child("close_city");
	close_city.pressed.connect(func():
		city_panel.visible = false;
	);
	
	park_panel = self.find_child("park_panel");
	close_park = self.find_child("close_park");
	close_park.pressed.connect(func():
		park_panel.visible = false;
	);
