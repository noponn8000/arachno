class_name EnemyAI;
extends Node2D;

var velocity := Vector2.ZERO;
var attacking := false;

func get_velocity() -> Vector2:
	return velocity;

func is_attacking() -> bool:
	return attacking;
