extends Sprite2D

const sprites := [
	preload("res://assets/web_aoe/web1.png"),
	preload("res://assets/web_aoe/web2.png"),
	preload("res://assets/web_aoe/web3.png")
];

@export_range (0, 2, 1) var sprite_index := 0;
@export var randomise := true;
@export var lifetime := 1.0;

func _ready() -> void:
	if randomise:
		sprite_index = randi_range(0, 2);
		rotation = randf_range(0, TAU);

	texture = sprites[sprite_index];

	var tween = get_tree().create_tween();
	tween.tween_property(self, "modulate", Color.TRANSPARENT, lifetime);
