class_name TrajectoryProjectile;
extends PathFollow2D

@export var speed := 15; # Speed in pixels per second
@export var rotation_speed := 20.0; # Rotation speed in radians per second

@onready var anim := $AnimationPlayer;
@onready var sprite := $Sprite2D;

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

	await anim.animation_finished;
	emit_signal("hit");
	queue_free();
