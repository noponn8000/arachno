extends Path2D

@export var curve_height := 100;
@export var mouse_sensitivity := 0.5;
@export var preview_point_count := 10;
@export var preview_point_scene: PackedScene = preload("res://scenes/trajectory_preview_point.tscn");
@export var preview_point_speed := 30; # pixels per second
@export var line_width := 2.0;
@export var line_color := Color.WHITE;
@export var anchor: Node2D;

var preview_points := [];

func _ready() -> void:
	for i in range(preview_point_count):
		var new_point = preview_point_scene.instantiate();
		add_child(new_point);
		preview_points.append(new_point);
		new_point.progress_ratio = i * (1.0 / preview_point_count);

func update_preview_point_ratios() -> void:
	for i in range(preview_point_count):
		preview_points[i].progress_ratio = i * (1.0 / preview_point_count);

func _draw() -> void:
	if line_width > 0:
		draw_polyline(curve.get_baked_points(), Color.WHITE, line_width);

func _process(delta: float) -> void:
	for point in preview_points:
		point.progress += preview_point_speed * delta;

	var mouse_pos := get_global_mouse_position();
	var parent_pos: Vector2 = anchor.global_position;
	var mouse_offset: Vector2 = mouse_pos - parent_pos;

	var middle_point := Vector2(parent_pos.x + mouse_offset.x / 2, parent_pos.y + (mouse_offset.y / 2 - curve_height - abs(mouse_offset.x * mouse_sensitivity)));
	curve.set_point_position(0, parent_pos);

	curve.set_point_position(1, middle_point);
	curve.set_point_position(2, mouse_pos);

	curve.set_point_in(1, -mouse_offset / 2);
	curve.set_point_out(1, mouse_offset / 2);

	queue_redraw();

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		update_preview_point_ratios();
