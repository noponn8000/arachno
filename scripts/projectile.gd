class_name Projectile;
extends CharacterBody2D

@export var speed := 100.0;
@export var spread := 20.0; # Angle of projectile spread in degrees

@onready var visibility_notifier = $VisibleOnScreenNotifier2D;

var direction := Vector2.UP;

func _ready() -> void:
	set_physics_process(false);
	visible = false;

# Call when you want to fire the projectile.
# Provide the direction to fire in and the starting position of the projectile.
func fire(dir: Vector2, pos: Vector2) -> void:
	visible = true;

	# Set the direction and add random spread.
	direction = dir.rotated(randf_range(deg_to_rad(-spread / 2), deg_to_rad(spread / 2)));
	global_position = pos;

	set_physics_process(true);

func _physics_process(delta: float) -> void:
	if not visibility_notifier.is_on_screen():
		queue_free();
	if get_slide_collision_count() > 0:
		# Hit a part of the environment
		on_terrain_hit();

	velocity = direction * speed;

	move_and_slide();

func on_terrain_hit() -> void:
	queue_free();
