class_name Inventory;
extends Control;

@onready var main_notches := $MainNotches.get_children();
@onready var side_notches := [];
@onready var item_node := $Items;

@export var side_notch_count := 16;

var preview_item: InventoryItem = null;
var preview_notch_idx: int = -1;

signal animation_finished;

func get_all_notches() -> Array:
	return main_notches + side_notches;

func _ready() -> void:
	for i in range(side_notch_count):
		var side_notch = InventoryNotch.new();
		side_notch.sprite_index = 0;
		side_notch.scale = Vector2(4, 4);
		side_notch.type = 1;

		$SideNotches.add_child(side_notch);
		side_notches.append(side_notch);

		if i % 2 != 0:
			side_notch.position = Vector2(32, i / 2 * 32);
		else:
			side_notch.position = Vector2(0, i / 2 * 32);

		side_notch.initialize();

	for item in $Items.get_children():
		item.connect("equip", on_item_equip_changed);
		add_inventory_item(item);

	Global.player_inventory = self;

# Returns an array with the index of the closest notch to `pos`
# and global position vector of it.
func get_closest_notch(pos: Vector2) -> Array:
	var current_notch: InventoryNotch = null;
	var closest_dist := 10e9;
	var closest_notch_index := 0;
	var closest_notch_position := Vector2.ZERO;

	var all_notches := get_all_notches();

	for index in all_notches.size():
		current_notch = all_notches[index];
		var notch_pos: Vector2 = current_notch.get_anchor_position();
		var distsq := pos.distance_squared_to(notch_pos);

		if distsq < closest_dist:
			closest_dist = distsq;
			closest_notch_index = index;
			closest_notch_position = notch_pos;

	return [closest_notch_index, closest_notch_position];

func set_equipped_item(index: int, replace: bool, item: InventoryItem) -> bool:
	var notch = get_all_notches()[index];

	if not notch.occupied or replace:
		unset_preview_item();
		notch.item = item;
		notch.occupied = item != null;

		print(get_equipped_items());
		print(get_inventory_items());

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
	preview_item.global_position = get_all_notches()[slot_index].get_anchor_position();

	preview_item.animate_preview();

func get_item_index(item: InventoryItem) -> int:
	var all_notches = get_all_notches();
	for i in len(all_notches):
		if all_notches[i].item == item:
			return i;

	return -1;

func get_equipped_items() -> Array[InventoryItem]:
	var items: Array[InventoryItem] = [];
	for notch in main_notches:
		if notch.occupied:
			items.append(notch.item);

	return items;

func get_inventory_items() -> Array[InventoryItem]:
	var items: Array[InventoryItem] = [];
	for notch in side_notches:
		if notch.occupied:
			items.append(notch.item);

	return items;

func unset_preview_item() -> void:
	if preview_item:
		preview_item.queue_free();
		preview_item = null;

func on_item_equip_changed(item: InventoryItem, equipped: bool) -> void:
	var item_index := get_item_index(item);
	if not equipped and item_index != -1:
		set_equipped_item(item_index, true, null);

func add_inventory_item(item: InventoryItem) -> bool:
	for notch in side_notches:
		if not notch.occupied:
			notch.item = item;
			notch.occupied = true;
			item.equipped = true;
			item.global_position = notch.get_anchor_position();

			item_node.add_child(item);
			item.visible = true;

			return true;

	return false;

func animate(state: bool) -> void:
	var tween = get_tree().create_tween();
	if state:
		visible = true;
		scale = Vector2.ZERO;

		tween.tween_property(self, "scale", Vector2.ONE, 0.5);
	else:
		scale = Vector2.ONE;
		tween.tween_property(self, "scale", Vector2.ZERO, 0.5);

	await tween.finished;
	emit_signal("animation_finished");
