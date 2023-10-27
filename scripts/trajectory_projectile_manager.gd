class_name TrajectoryProjectileManager;
extends Node2D

@onready var trajectory: Path2D = $Trajectory

@export var cooldown := 0.5;
@export var projectile_scene: PackedScene = preload("res://scenes/trajectory_projectile.tscn");

var can_shoot := true;

func shoot() -> void:
	if not can_shoot:
		return;

	var projectile := projectile_scene.instantiate();

	# Copy the Path2D so that the projectile's trajectory doesn't change when the preview moves.
	var trajectory_copy := Path2D.new();
	trajectory_copy.curve = trajectory.curve.duplicate();
	get_tree().root.add_child(trajectory_copy);

	trajectory_copy.add_child(projectile);
	projectile.fire();

	can_shoot = false;
	get_tree().create_timer(cooldown).connect("timeout", func() : can_shoot = true);

	await projectile.hit;

	trajectory_copy.queue_free();
