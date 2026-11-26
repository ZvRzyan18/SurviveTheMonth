extends Button


func _change_scene():
	self.get_tree().change_scene_to_file("res://ollet_folder/scenes/FirstScene.tscn");

func _ready() -> void:
	self.pressed.connect(_change_scene);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
