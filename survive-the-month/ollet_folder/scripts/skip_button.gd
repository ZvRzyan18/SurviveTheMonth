
extends Sprite2D

@export var nodes_to_show: Array[Node2D] = []
@export var display_names: Array[String] = []

var menu_layer: CanvasLayer
var panel: Panel
var container: VBoxContainer

func _ready():
	for node in nodes_to_show:
		if node:
			node.hide()

	create_menu()

func create_menu():
	menu_layer = CanvasLayer.new()
	get_tree().root.add_child.call_deferred(menu_layer)

	panel = Panel.new()
	panel.custom_minimum_size = Vector2(400, 350)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-200, -175)
	menu_layer.add_child(panel)

	container = VBoxContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_theme_constant_override("separation", 12)
	panel.add_child(container)

	var title = Label.new()
	title.text = "CHOOSE WHAT TO SHOW"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	container.add_child(title)

	for i in range(nodes_to_show.size()):
		if nodes_to_show[i]:
			var button = Button.new()

			if i < display_names.size() and display_names[i] != "":
				button.text = display_names[i]
			else:
				button.text = nodes_to_show[i].name

			button.custom_minimum_size = Vector2(0, 55)
			button.add_theme_font_size_override("font_size", 20)
			button.pressed.connect(_on_node_selected.bind(i))
			container.add_child(button)

	menu_layer.hide()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_rect().has_point(to_local(get_global_mouse_position())):
				menu_layer.show()
				get_viewport().set_input_as_handled()

func _on_node_selected(id):
	for node in nodes_to_show:
		if node:
			node.hide()

	if id < nodes_to_show.size() and nodes_to_show[id]:
		nodes_to_show[id].show()

	menu_layer.hide()
