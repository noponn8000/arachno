class_name TrajectoryProjectile;
extends PathFollow2D

@export var speed := 15; # Speed in pixels per second
@export var rotation_speed := 20.0; # Rotation speed in radians per second
@export var web_scene: PackedScene = preload("res://scenes/cobweb.tscn");
@export var web_count := 5;
@export var aoe_radius := 15.0;

@onready var anim := $AnimationPlayer;
@onready var sprite := $Projectile;

var firing := false;

signal hit;

func fire() -> void:
	visible = true;
	firing = true;

func _physics_process(delta: float) -> void:
	if (firing):
		sprite.rotation += rotation_speed * delta;

		progress += speed * delta;
		if progress_ratio == 1.0:
			firing = false;
			explode();

func explode() -> void:
	anim.play("explode");
	spawn_cobwebs();

	await anim.animation_finished;
	emit_signal("hit");
	queue_free();

func spawn_cobwebs() -> void:
	for _i in range(web_count):
		var angle := randf_range(0, TAU);
		var magnitude := randf_range(aoe_radius / 2, aoe_radius);

		var web_position := (Vector2.UP * magnitude).rotated(angle);

		var cobweb := web_scene.instantiate();
		$Webs.add_child(cobweb);
		cobweb.position = web_position;
