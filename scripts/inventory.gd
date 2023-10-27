@tool
class_name InventoryWindow;
extends Control;

@onready var top: Node2D = $Top
@onready var middle: Node2D = $Middle
@onready var bottom: Node2D = $Bottom

@onready var middle_column := [$Top/BoxTop, $Middle/BoxFill, $Bottom/BoxBottom];
@onready var right_column := [$Top/BoxTopRight, $Middle/BoxRight, $Bottom/BoxBottomRight];

@export_range(64, 640, 1) var window_width: float = 64;
@export_range(64, 640, 1) var window_height: float = 64;

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		update_dimensions();

func _ready() -> void:
	update_dimensions();

func update_dimensions() -> void:
	# Update height
	var middle_height: int = window_height - 32;
	for middle_node in middle.get_children():
		middle_node.region_rect.size.y = middle_height;

	middle.position.y = middle_height / 2 + 8;
	bottom.position.y = middle_height + 16;

	# Update width
	var middle_width: int = window_width - 32;
	for middle_node in middle_column:
		middle_node.region_rect.size.x = middle_width;
		middle_node.position.x = middle_width / 2 + 16;

	for right_node in right_column:
		right_node.position.x = middle_width + 24;

	size = Vector2i(window_width, window_height);
