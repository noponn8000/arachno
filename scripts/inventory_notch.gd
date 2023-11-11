@tool
class_name InventoryNotch
extends Sprite2D;

enum NOTCH_TYPE {MAIN, SIDE};

@export_range (0, 9, 1) var sprite_index := 0;
@export var item: InventoryItem;

var occupied := false;
var type := NOTCH_TYPE.MAIN;
var anchor_position: Vector2;

func _ready() -> void:
	initialize();

func _enter_tree() -> void:
	initialize();

func initialize() -> void:
	if get_child_count() > 0:
		anchor_position = get_child(0).global_position;
	else:
		anchor_position = to_global(Vector2(-0.5, -0.5));

	texture = preload("res://assets/inventory/notches.png");
	hframes = 9;
	frame = sprite_index;
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST;

	if item:
		occupied = true;
	else:
		occupied = false;

func get_anchor_position() -> Vector2:
	return anchor_position;

func set_item(item: InventoryItem) -> void:
	if item == self.item:
		return;

	self.item = item;
	add_child(item);
	occupied = true;
	item.equipped = true;
	item.global_position = get_anchor_position();
	item = null;
	occupied = false;

func unset_item() -> void:
	if item:
		remove_child(item);
		item.equipped = false;

	item = null;
	occupied = false;
