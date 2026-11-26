extends CharacterBody3D


const SPEED = 120.0
const JUMP_VELOCITY = 4.5

var y_axis : Node3D = null;
var x_axis : Node3D = null;
var camera : Camera3D = null;

var dragging : bool = false;

var prev_position : Vector2 = Vector2.ZERO;
var sensitivity : float = 0.01;

func _ready() -> void:
	y_axis = self.find_child("y_axis");
	x_axis = self.find_child("x_axis");
	camera = self.find_child("camera_view");

func _input(event : InputEvent):
		
	if event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = event as InputEventMouseButton;
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_RIGHT:
			dragging = true;
			prev_position = mouse_event.position;
		else :
			dragging = false
			
	if dragging and event is InputEventMouseMotion :
		var mouse_motion : InputEventMouseMotion = event as InputEventMouseMotion;
		var delta_position : Vector2 = prev_position - mouse_motion.position;
		y_axis.rotation.y += delta_position.x * sensitivity;
		x_axis.rotation.x += delta_position.y * sensitivity;
		
		x_axis.rotation.x = clampf(x_axis.rotation.x, -0.4, 0.4);
		prev_position = mouse_motion.position
		GlobalState.player_rotate.emit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		self.velocity += get_gravity() * delta
	else :
		self.velocity.y = 0.0;
		
	const pio2 : float = PI / 2.0;
	
	if Input.is_action_pressed("move_forward"):
		self.velocity = Vector3(-sin(y_axis.rotation.y), self.velocity.y, -cos(y_axis.rotation.y)) * SPEED * delta;
	elif Input.is_action_pressed("move_backward"):
		self.velocity = Vector3(sin(y_axis.rotation.y), self.velocity.y, cos(y_axis.rotation.y)) * SPEED * delta;
	elif Input.is_action_pressed("move_right"):
		self.velocity = Vector3(sin(y_axis.rotation.y + pio2), self.velocity.y, cos(y_axis.rotation.y + pio2)) * SPEED * delta;
	elif Input.is_action_pressed("move_left"):
		self.velocity = Vector3(-sin(y_axis.rotation.y + pio2), self.velocity.y, -cos(y_axis.rotation.y + pio2)) * SPEED * delta;
	else:
		self.velocity *= Vector3(0.0, 1.0, 0.0);
	GlobalState.player_position = self.position;
	GlobalState.player_rotation = Vector3(x_axis.rotation.x, y_axis.rotation.y, 0.0);
	move_and_slide()
