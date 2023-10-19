class_name EnemySpawer;
extends Node2D

@export var enemy_weights := {1.0: preload("res://scenes/ghost.tscn")}
@export var interval_min := 5.0;
@export var interval_max := 10.0;
@export var bounds_top_left := Vector2.ZERO;
@export var bounds_bottom_right := Vector2.ZERO;
@export var spawning := false;

var can_spawn := true;

func _process(delta) -> void:
	if spawning and can_spawn:
		can_spawn = false;
		spawn_enemy();
		
		get_tree().create_timer(randf_range(interval_min, interval_max)).connect("timeout", on_interval_finished);

func on_interval_finished() -> void:
	can_spawn = true;
	
func spawn_enemy() -> void:
	var enemy = choose_random_enemy().instantiate();
	
	var random_x = randf_range(bounds_top_left.x, bounds_bottom_right.x);
	var random_y = randf_range(bounds_top_left.y, bounds_bottom_right.x);
	
	get_tree().add_child(enemy);
	enemy.global_position = Vector2(random_x, random_y);

func choose_random_enemy() -> PackedScene:
	var random_value := randf();
	
	for weight in enemy_weights.keys():
		if weight >= random_value:
			return enemy_weights[weight];
			
	# Enemy weights dictionary is empty
	return null;
