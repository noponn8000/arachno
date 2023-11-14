class_name RespawnPoint;
extends Area2D;

@export var activated := false;
@export var respawn_point: Marker2D;

func _ready() -> void:
	body_entered.connect(on_body_entered);

func on_body_entered(other: Node2D) -> void:
	if other is Player:
		activated = true;

func get_respawn_position() -> Vector2:
	if respawn_point:
		return respawn_point.global_position;
	else:
		return self.global_position;
