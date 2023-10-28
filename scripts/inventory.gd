class_name Inventory;
extends Control;

@onready var main_notches := $MainNotches.get_children();

# Returns an array with the index of the closest notch to `pos`
# and global position vector of it.
func get_closest_notch(pos: Vector2) -> Array:
	var current_notch: InventoryNotch = null;
	var closest_dist := 10e9;
	var closest_notch_index := 0;
	var closest_notch_position := Vector2.ZERO;

	for index in main_notches.size():
		current_notch = main_notches[index];
		var distsq := pos.distance_squared_to(
			current_notch.get_node("Marker2D").global_position
		);

		if distsq < closest_dist:
			closest_dist = distsq;
			closest_notch_index = index;
			closest_notch_position = current_notch.global_position;

	return [closest_notch_index, closest_notch_position];

func set_equipped_item(index: int, replace: bool, item: InventoryItem) -> void:
	var notch = main_notches[index];
	if not notch.occupied or replace:
		notch.item = item;
