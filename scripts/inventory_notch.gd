@tool
class_name InventoryNotch
extends Sprite2D;

@export_range (0, 9, 1) var sprite_index := 0;
@export var item: InventoryItem;

@onready var anchor_marker := $Marker2D;

var occupied := false;

func _ready() -> void:
	initialize();

func _enter_tree() -> void:
	initialize();

func initialize() -> void:
	texture = preload("res://assets/inventory/notches.png");
	hframes = 9;
	frame = sprite_index;

	if item:
		occupied = true;
	else:
		occupied = false;

func get_anchor_position() -> Vector2:
	return anchor_marker.global_position;
