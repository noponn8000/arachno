class_name Inventory;
extends Control;

@onready var main_notches := $MainNotches.get_children();

var preview_item: InventoryItem = null;
var preview_notch_idx: int = -1;

# Returns an array with the index of the closest notch to `pos`
# and global position vector of it.
func get_closest_notch(pos: Vector2) -> Array:
	var current_notch: InventoryNotch = null;
	var closest_dist := 10e9;
	var closest_notch_index := 0;
	var closest_notch_position := Vector2.ZERO;

	for index in main_notches.size():
		current_notch = main_notches[index];
		var notch_pos: Vector2 = current_notch.get_anchor_position();
		var distsq := pos.distance_squared_to(notch_pos);

		if distsq < closest_dist:
			closest_dist = distsq;
			closest_notch_index = index;
			closest_notch_position = notch_pos;

	return [closest_notch_index, closest_notch_position];

func set_equipped_item(index: int, replace: bool, item: InventoryItem) -> bool:
	var notch = main_notches[index];

	if not notch.occupied or replace:
		unset_preview_item();
		notch.item = item;

		return true;

	return false;

func set_preview_item(item: InventoryItem, slot_index: int) -> void:
	if preview_item and item.id == preview_item.id and slot_index == preview_notch_idx:
		return;

	# Remove previous item
	if preview_item:
		preview_item.queue_free();

	# Duplicate the selected item and add it to the inventory node.
	preview_item = item.duplicate();
	preview_item.is_preview = true;
	preview_notch_idx = slot_index;
	add_child(preview_item);

	# Set the item's position to the chosen notch's anchor point.
	preview_item.global_position = main_notches[slot_index].get_anchor_position();

	preview_item.animate_preview();

func unset_preview_item() -> void:
	if preview_item:
		preview_item.queue_free();
		preview_item = null;
