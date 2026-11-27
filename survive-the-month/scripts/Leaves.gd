@tool
extends Node3D
class_name LeavesMasked

var rng_position_x : RandomNumberGenerator = null
var rng_position_y : RandomNumberGenerator = null
var rng_position_z : RandomNumberGenerator = null

var multi_mesh_instance : MultiMeshInstance3D = null

## Amount of object that is being drawn.
@export
var instance_count : int = 10:
	set(val):
		instance_count = val
		initialize()

## Seed for randomized position
@export
var seed_position : Vector3i = Vector3i(4545, 1232, 9444):
	set(val):
		seed_position = val
		initialize()


## Max range of the randomized position
@export
var randomized_position_area : Vector3 = Vector3(5.0, 5.0, 5.0):
	set(val):
		randomized_position_area = val
		initialize()

## Mesh object 
@export
var mesh_type : Mesh = null:
	set(val):
		mesh_type = val
		initialize()

## cast shadow settings
@export_enum("CAST_SHADOW_ON", "CAST_SHADOW_OFF", "CAST_SHADOW_DOUBLE_SIDED", "CAST_SHADOW_SHADOWS_ONLY")
var cast_shadow : int = 0:
	set(val):
		cast_shadow = val
		initialize()


@export
var shader_material : ShaderMaterial = null:
	set(val) :
		shader_material = val
		initialize()

func create_objects() -> void:
	rng_position_x = RandomNumberGenerator.new()
	rng_position_x.seed = seed_position.x
	rng_position_y = RandomNumberGenerator.new()
	rng_position_y.seed = seed_position.y
	rng_position_z = RandomNumberGenerator.new()
	rng_position_z.seed = seed_position.z	

func initialize() -> void:
	if mesh_type == null :
		return
	create_objects()
	for child : Node in get_children():
		remove_child(child)
		child.queue_free()
	
	if multi_mesh_instance != null:
		multi_mesh_instance.queue_free()
		multi_mesh_instance = null
		
	multi_mesh_instance = MultiMeshInstance3D.new()
	multi_mesh_instance.multimesh = MultiMesh.new()
	multi_mesh_instance.multimesh.mesh = mesh_type
	multi_mesh_instance.material_override = shader_material
	
	match cast_shadow:
		0:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		1:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		2:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
		3:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY


	if multi_mesh_instance.multimesh != null:
		multi_mesh_instance.multimesh.instance_count = 0
		multi_mesh_instance.multimesh.transform_format = MultiMesh.TransformFormat.TRANSFORM_3D
		multi_mesh_instance.multimesh.instance_count = instance_count
	for i : int in range(0, multi_mesh_instance.multimesh.instance_count):
			multi_mesh_instance.multimesh.set_instance_transform(i, Transform3D(Basis(), Vector3(rng_position_x.randf(), rng_position_y.randf(), rng_position_z.randf()) * randomized_position_area))
		
		
	add_child(multi_mesh_instance)
func _ready() -> void:
	initialize()
