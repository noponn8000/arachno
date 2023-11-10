class_name DamageNumberComponent;
extends Node2D;

@export var number_scene: PackedScene;
@export_range(0, 360) var spread_min := 20;
@export_range(0, 360) var spread_max := 40;
@export var lifetime_min := 1.0;
@export var lifetime_max := 2.0;
@export var scale_min := 0.5;
@export var scale_max := 1.0;
@export var range_min := 20.0;
@export var range_max := 40.0;
@export var direction := Vector2.UP;

func spawn_number(damage: int) -> void:
	var angle = randf_range(deg_to_rad(spread_min), deg_to_rad(spread_max));
	var magnitude = randf_range(range_min, range_max);
	var end_position = global_position + (direction * magnitude).rotated(angle);

	var number := number_scene.instantiate();
	number.global_position = global_position;
	number.scale = Vector2.ONE * randf_range(scale_min, scale_max);
	number.end_position = end_position;
	number.lifetime = randf_range(lifetime_min, lifetime_max);
	number.damage = damage;

	get_tree().root.add_child(number);
