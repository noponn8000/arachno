@tool
extends Line2D;

@export var object_scene: PackedScene;
var parent_node;

func _ready() -> void:
	await get_tree().root.ready;

	place_objects();

func _process(_delta: float) -> void:
	if (Engine.is_editor_hint()):
		place_objects();
		#create_polygon();
		set_process(false);

func place_objects() -> void:
	var i = 0;
	for point in get_points():
			var object = object_scene.instantiate();
			object.global_position = to_global(point);
			if object is StaticBody2D:
				object.type = rand_from_seed(i)[0] % 3;
				object.update_type();
			get_parent().add_child(object);

			i += 1;
