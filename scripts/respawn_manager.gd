class_name RespawnManager;

extends Node;

@export var respawn_points: Array;

func _ready() -> void:
	respawn_points = get_children();

func get_closest_respawn_point() -> RespawnPoint:
	var closest_point = null;
	print(respawn_points);
	for point in respawn_points:
		print(point);
		if point.activated:
			if closest_point == null:
				closest_point = point;
			elif ( point.get_respawn_position().distance_squared_to(Global.player.global_position) <
				closest_point.get_respawn_position().distance_squared_to(Global.player.global_position)
			):
				closest_point = point;

	return closest_point;
