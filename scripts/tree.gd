@tool
extends StaticBody2D

enum TREE_TYPE {MEDIUM, SMALL, LARGE};

@export var type := TREE_TYPE.SMALL;

func _ready() -> void:
	update_type();

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_type();

func update_type() -> void:
		$Sprite2D.frame = type;
