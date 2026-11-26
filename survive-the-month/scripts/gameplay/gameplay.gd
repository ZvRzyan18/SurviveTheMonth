extends Control


var money_display : Label = null;
var day_display : Label = null;


func _ready() -> void:
	money_display = self.find_child("money_display");
	day_display = self.find_child("day_display");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	money_display.text = "Money : " + str(GlobalState.player_money);
	day_display.text = "Day : " + str(GlobalState.current_day);
