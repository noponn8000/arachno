extends CharacterBody2D

@onready var pivot := $Pivot;
@onready var attack_anim := $Pivot/BiteSprite/AnimationPlayer;
@onready var sprite_anim := $Pivot/Legs/LegAnimationPlayer;
@onready var hurtbox := $Hurtbox;
@onready var dash_particles := $Pivot/DashParticles
@onready var projectile_manager := $TrajectoryProjectileManager;
@onready var health_manager := $HealthManager;
@onready var projectile_marker := $Pivot/ProjectileMarker;

@export var movement_speed := 100.0;
@export var rotation_speed := 0.5; # Rotation speed between 0.0 and 1.0
@export var acceleration := 50.0;
@export var friction := 100.0;
@export var dash_speed := 200.0;
@export var dash_cooldown := 0.8;
@export var dash_duration := 0.25;
@export var projectile_cooldown := 0.5;

var input_direction := Vector2.ZERO;
var can_attack := true;
var can_shoot := true;

# Dash
var dash_direction := Vector2.ZERO;
var can_dash := true;
var dashing := false;

enum AttackType { LIGHT, HEAVY };

func _ready() -> void:
	attack_anim.connect("animation_finished", attack_cooldown_finished);
	sprite_anim.play("newmove");
	attack_anim.play("RESET");

	hurtbox.connect("damage_taken", on_damage_taken);

func _physics_process(delta) -> void:
	input_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"));
	rotate_sprite();
	animate_sprite();

	if Input.is_action_pressed("attack1"):
		attack(AttackType.LIGHT);
	elif Input.is_action_just_pressed("attack2"):
		attack(AttackType.HEAVY);
	elif Input.is_action_pressed("shoot"):
		shoot_projectile();

	if Input.is_action_pressed("dash") and can_dash:
		dash();

	if dashing:
		velocity = dash_direction * dash_speed;
	else:
		velocity = input_direction * movement_speed;
	move_and_slide();

func dash() -> void:
	dash_direction = -global_position.direction_to(get_global_mouse_position());
#	if input_direction:
#		dash_direction = input_direction;
#	else:
#		dash_direction = Vector2.ZERO;

	dashing = true;
	can_dash = false;

	dash_particles.restart();
	get_tree().create_timer(dash_duration).connect("timeout", dash_finished);
	get_tree().create_timer(dash_cooldown).connect("timeout", dash_cooldown_finished);

func shoot_projectile() -> void:
	if can_shoot:
#		var projectile = projectile_scene.instantiate();
#		get_tree().root.add_child(projectile);
#
#		projectile.fire(
#			global_position.direction_to(projectile_marker.global_position),
#			projectile_marker.global_position
#		);
#		can_shoot = false;
		projectile_manager.shoot();

		get_tree().create_timer(projectile_cooldown).connect("timeout", projectile_cooldown_finished);

func rotate_sprite() -> void:
	pivot.look_at(get_global_mouse_position());
	pivot.rotation_degrees -= 90;

func animate_sprite() -> void:
	if input_direction:
		var direction_to_mouse = global_position.direction_to(get_global_mouse_position());

		if direction_to_mouse.dot(input_direction) > 0:
			sprite_anim.play();
		else:
			sprite_anim.play_backwards();
	else:
		sprite_anim.stop();

func attack(type: AttackType) -> void:
	if not can_attack:
		return;

	can_attack = false;
	if type == AttackType.LIGHT:
		attack_anim.speed_scale = 2.0;
		attack_anim.play("fast_bite");
	elif type == AttackType.HEAVY:
		attack_anim.speed_scale = 1.0;
		attack_anim.play("heavy_bite");

func attack_cooldown_finished(animation: String) -> void:
	can_attack = true;

func dash_cooldown_finished() -> void:
	can_dash = true;

func projectile_cooldown_finished() -> void:
	can_shoot = true;

func dash_finished() -> void:
	dashing = false;
	dash_particles.emitting = false;

func on_damage_taken(hitbox: Hitbox) -> void:
	health_manager.change_health(-hitbox.damage);
