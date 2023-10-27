extends Node2D

@onready var player := get_tree().get_first_node_in_group("player");

func update_rotation() -> void:
	look_at(player.global_position);
