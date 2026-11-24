@tool
extends Node3D
class_name Leaves
 
var multi_mesh_instance: MultiMeshInstance3D

@export var instance_count: int = 10:
	set(v):
		instance_count = v;
		initialize();

@export var seed_position: Vector3i = Vector3i(4544, 2232, 9434):
	set(v):
		seed_position = v;
		initialize();

@export var randomized_position_area: Vector3 = Vector3(5.0, 5.0, 5.0):
	set(v):
		randomized_position_area = v;
		initialize();

@export var mesh_type: Mesh:
	set(v):
		mesh_type = v;
		initialize();

@export var shader_material: ShaderMaterial:
	set(v):
		shader_material = v;
		initialize();

@export_enum(
	"CAST_SHADOW_ON",
	"CAST_SHADOW_OFF",
	"CAST_SHADOW_DOUBLE_SIDED",
    "CAST_SHADOW_SHADOWS_ONLY"
)
var cast_shadow: int = 0:
	set(v):
		cast_shadow = v;
		initialize();



func initialize() -> void:
	if mesh_type == null:
		return

	var rng_x := RandomNumberGenerator.new()
	var rng_y := RandomNumberGenerator.new()
	var rng_z := RandomNumberGenerator.new()

	rng_x.seed = seed_position.x
	rng_y.seed = seed_position.y
	rng_z.seed = seed_position.z

	if is_instance_valid(multi_mesh_instance):
		multi_mesh_instance.queue_free()

	multi_mesh_instance = MultiMeshInstance3D.new()

	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh_type
	mm.instance_count = instance_count

	multi_mesh_instance.multimesh = mm
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

	for i in range(instance_count):
		var _position := Vector3(
			rng_x.randf(),
			rng_y.randf(),
			rng_z.randf()
		) * randomized_position_area

		mm.set_instance_transform(
			i,
			Transform3D(Basis(), _position)
		)

	add_child(multi_mesh_instance)


func _ready() -> void:
	initialize()
