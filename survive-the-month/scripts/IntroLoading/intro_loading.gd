extends Control

var message : Label = null;
var loading : ProgressBar = null;
var progress : float = 9.8;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	message = find_child("LoadingMessage")
	loading = find_child("Loading");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loading.value = loading.value + progress * delta;
	if(loading.value > 20.0):
		message.text = "[2] Extracting Resources...";
		progress = 7.8;
	if(loading.value > 75.0):
		message.text = "[3] Checksum Validation...";
		progress = 12.8;
	if(loading.value > 90.0):
		progress = 3.8;
		message.text = "[4] Compiling Shaders...";
	if(loading.value >= 99.0):
		message.text = "[5] Starting...";
		await self.get_tree().create_timer(3.5).timeout
		self.get_tree().change_scene_to_file("res://scenes/MainMenu.tscn");
