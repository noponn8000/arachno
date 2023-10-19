@tool
extends Line2D;

@export var object_scene: PackedScene;

var parent_node;

func _ready() -> void:
	await get_tree().root.ready;
	visible = false;
	
	place_trees();

func _process(delta: float) -> void:
	if (Engine.is_editor_hint()):
		place_trees();
		set_process(false);
		
func place_trees() -> void:
	for point in get_points():
			var object = object_scene.instantiate();
			object.global_position = point;
			get_parent().add_child(object);
