extends Node2D

var lifetime: float;
var end_position: Vector2;
var damage: int;

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var number_label: Label = $NumberLabel

func _ready() -> void:
	number_label.text = str(damage);

	var tween = get_tree().create_tween();
	tween.tween_property(self, "global_position", end_position, lifetime);

	animation_player.speed_scale = 1.0 / lifetime;
	animation_player.play("fade");

	await animation_player.animation_finished;
	queue_free();
