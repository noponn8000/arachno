@tool
extends Line2D;

@export var object_scene: PackedScene;
@onready var exclusion_polygon := $ExclusionPolygon;
@onready var boundary_polygon := $BoundaryPolygon2D
var parent_node;

func _ready() -> void:
	await get_tree().root.ready;
	#boundary_polygon.visible = true;

	place_trees();
	#create_polygon();

func _process(delta: float) -> void:
	if (Engine.is_editor_hint()):
		place_trees();
		#create_polygon();
		set_process(false);

func place_trees() -> void:
	var i = 0;
	for point in get_points():
			var object = object_scene.instantiate();
			object.global_position = point;
			object.type = rand_from_seed(i)[0] % 3;
			object.update_type();
			get_parent().add_child(object);

			i += 1;

func create_polygon() -> void:
	exclusion_polygon.polygon = points;
	exclusion_polygon.color = Color.TRANSPARENT;

	boundary_polygon.polygon = Geometry2D.exclude_polygons(boundary_polygon.polygon, exclusion_polygon.polygon)[1];
	print(boundary_polygon.polygon);
