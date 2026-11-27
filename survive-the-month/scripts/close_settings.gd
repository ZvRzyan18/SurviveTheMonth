extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(func():
		self.get_parent().get_parent().visible = false;
	);
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
