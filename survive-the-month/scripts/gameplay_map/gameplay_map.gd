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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
