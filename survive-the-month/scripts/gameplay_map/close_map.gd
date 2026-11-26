extends Button

func on_click() :
	self.get_tree().change_scene_to_file("res://scenes/Gameplay.tscn");
	
func _ready() -> void:
	self.pressed.connect(on_click);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
