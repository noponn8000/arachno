@tool
extends StaticBody2D

enum TREE_TYPE {MEDIUM, SMALL, LARGE};

@export var type := TREE_TYPE.SMALL;
@export var randomise := true;
@export var random_seed := 100;

func _ready() -> void:
	if randomise:
		type = randi_range(0, 2);
		#$Sprite2D.flip_h = randf() > 0.5;

	$Sprite2D.frame = type;

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$Sprite2D.frame = type;
