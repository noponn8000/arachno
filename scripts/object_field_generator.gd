class_name ObjectFieldSpawner;
extends Node2D

@export var object_scene: PackedScene;
@export var shape: Polygon2D;

func _ready() -> void:
	spawn_objects();

func spawn_objects() -> void:
	for point in shape.polygon:
		var object = object_scene.instantiate();
		object.global_position = point;

		add_child(object);
