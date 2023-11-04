class_name InventoryItem;
extends Area2D;

@onready var inventory: Inventory = get_tree().get_first_node_in_group("inventory");

@export var snap_speed := 20.0;
@export var snap_range := 100.0;
@export var id := 0;

var origin_position: Vector2;
var snap_position: Vector2;
var snap_index: int;
var snapping := false;
var selected := false;
var equipped := false;
var is_preview := false;

func _ready() -> void:
	input_pickable = true;
	origin_position = global_position;

func _process(delta: float) -> void:
	if is_preview:
		set_process(false);
		input_pickable = false;
		return;

	if selected:
		show_preview();
		global_position = get_global_mouse_position();
	else:
		if find_snap_position():
			global_position = global_position.move_toward(snap_position, snap_speed);
			if !equipped:
				equipped = inventory.set_equipped_item(snap_index, false, self);
		else:
			global_position = origin_position;

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		selected = event.is_pressed();

func find_snap_position() -> bool:
	var notch_info := inventory.get_closest_notch(global_position);

	if notch_info[1].distance_to(global_position) < snap_range:
		snap_position = notch_info[1];
		snap_index = notch_info[0];
		return true;
	else:
		return false;

func show_preview() -> void:
	var notch_info := inventory.get_closest_notch(global_position);

	if notch_info[1].distance_to(global_position) < snap_range:
		inventory.set_preview_item(self, notch_info[0]);
	else:
		inventory.unset_preview_item();

func animate_preview() -> void:
	$AnimationPlayer.play("preview");
