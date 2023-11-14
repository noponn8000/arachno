class_name Player;
extends CharacterBody2D

enum STATE {WALKING, IDLE, ATTACKING, DASHING, WINDUP};

@onready var pivot := $Pivot;
@onready var attack_anim := $Pivot/BiteSprite/AnimationPlayer;
@onready var sprite_anim := $Pivot/Legs/LegAnimationPlayer;
@onready var hurtbox := $Hurtbox;
@onready var dash_particles := $Pivot/DashParticles
@onready var projectile_manager := $Pivot/TrajectoryProjectileManager;
@onready var health_manager := $HealthManager;
@onready var projectile_marker := $Pivot/ProjectileMarker;
@onready var projectile_sprite := $Pivot/Legs/ProjectileSprite;
@onready var fang_anim := $Pivot/Fangs/AnimationPlayer;
@onready var fang_sprite_l := $Pivot/Fangs/FangSpriteL
@onready var fang_sprite_r := $Pivot/Fangs/FangSpriteR
@onready var dash_sprite := $Pivot/DashSprite;
@onready var hitbox = $Pivot/BiteSprite/BiteArea2D;

@export var respawn_manager: RespawnManager;
@export var movement_speed := 100.0;
@export var rotation_speed := 0.5; # Rotation speed between 0.0 and 1.0
@export var acceleration := 50.0;
@export var friction := 100.0;
@export var dash_speed := 200.0;
@export var dash_cooldown := 0.8;
@export var dash_duration := 0.25;
@export var projectile_cooldown := 0.5;
@export var projectile_windup_duration := 1.0;
@export var heavy_attack_max_windup := 1.5;
@export var heavy_attack_cooldown := 0.5;

var state: STATE;
var input_direction := Vector2.ZERO;
var can_attack := true;
var can_shoot := true;
var concealed := false;
var impulse := Vector2.ZERO;

# Dash
var dash_direction := Vector2.ZERO;
var can_dash := true;
var dashing := false;

# Projectile
var projectile_windup_timer := 0.0;

# Attacks
var heavy_attack_windup_timer := 0.0;
var heavy_attack_cooldown_finished := true;

enum AttackType { LIGHT, HEAVY };

func _ready() -> void:
	attack_anim.connect("animation_finished", attack_cooldown_finished);
	sprite_anim.play("newmove");
	attack_anim.play("RESET");
	fang_anim.play("RESET");
	update_fang_sprites();

	hurtbox.connect("damage_taken", on_damage_taken);
	health_manager.connect("health_depleted", respawn);

	Global.player = self;

func _physics_process(delta) -> void:
	input_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"));
	rotate_sprite();
	animate_sprite();
	projectile_windup(delta);

	if state == STATE.WINDUP:
		return;

	if Input.is_action_pressed("attack1"):
		attack(AttackType.LIGHT);
	elif Input.is_action_pressed("attack2") and heavy_attack_cooldown_finished:
		if heavy_attack_windup_timer < 1.0 and fang_anim.current_animation != "fang_turn":
			fang_anim.play("fang_turn");

		heavy_attack_windup_timer += delta;

		if heavy_attack_windup_timer >= heavy_attack_max_windup:
			attack(AttackType.HEAVY);

		update_fang_sprites();
	elif Input.is_action_just_released("attack2"):
		if heavy_attack_windup_timer > 0.0:
			attack(AttackType.HEAVY);
		else:
			heavy_attack_windup_timer = 0.0;
			fang_anim.play("RESET");

	if Input.is_action_pressed("shoot"):
		shoot_projectile();

	if Input.is_action_pressed("dash") and can_dash:
		dash();

	if dashing:
		state = STATE.DASHING;
	else:
		if velocity != Vector2.ZERO:
			state = STATE.WALKING;
		else:
			state = STATE.IDLE;

	velocity = input_direction * movement_speed + impulse;
	move_and_slide();

func dash() -> void:
	if input_direction:
		apply_impulse(input_direction.normalized(), dash_speed, dash_duration);
	else:
		apply_impulse(
			-global_position.direction_to(get_global_mouse_position()),
			dash_speed,
			dash_duration
		);

	dashing = true;
	can_dash = false;
	#dash_sprite.visible = true;

	dash_sprite.frame = 0;
	dash_sprite.play();
	if input_direction != Vector2.ZERO:
		dash_sprite.global_rotation = Vector2.DOWN.angle_to(input_direction.normalized());
	else:
		dash_sprite.global_rotation = Vector2.DOWN.angle_to(-global_position.direction_to(get_global_mouse_position()));

	dash_particles.restart();
	get_tree().create_timer(dash_duration).connect("timeout", dash_finished);
	get_tree().create_timer(dash_cooldown).connect("timeout", dash_cooldown_finished);

func shoot_projectile() -> void:
	if can_shoot:
		projectile_manager.shoot(clamp(projectile_windup_timer, 0.5, 1.0));

		get_tree().create_timer(projectile_cooldown).connect("timeout", projectile_cooldown_finished);

func rotate_sprite() -> void:
	pivot.look_at(get_global_mouse_position());
	pivot.rotation_degrees -= 90;

func animate_sprite() -> void:
	if state == STATE.WINDUP:
		sprite_anim.play("ballmaking");
		return;
	else:
		if sprite_anim.current_animation == "ballmaking":
			sprite_anim.play("RESET");

	if input_direction != null and state == STATE.WALKING:
		var direction_to_mouse = global_position.direction_to(get_global_mouse_position());

		if direction_to_mouse.dot(input_direction) > 0:
			sprite_anim.play("newmove");
		else:
			sprite_anim.play_backwards("newmove");
	else:
		sprite_anim.stop();

func projectile_windup(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		state = STATE.WINDUP;
		projectile_sprite.scale = Vector2(
			min(projectile_sprite.scale.x + delta, 1.0),
			min(projectile_sprite.scale.y + delta, 1.0)
		);
		projectile_windup_timer += delta;
		projectile_manager.visible = true;
	elif Input.is_action_just_released("shoot"):
		if projectile_windup_timer > 0.0:
			shoot_projectile();
			projectile_windup_timer = 0.0;
			projectile_sprite.scale = Vector2.ZERO;
			state = STATE.IDLE;
			projectile_manager.visible = false;
			return;
		else:
			state = STATE.IDLE;
			projectile_sprite.scale = Vector2.ZERO;
			projectile_manager.visible = false;
			projectile_windup_timer = 0.0;
	else:
		projectile_sprite.scale = Vector2.ZERO;
		projectile_manager.visible = false;
		state = STATE.IDLE;

func attack(type: AttackType) -> void:
	if not can_attack:
		return;

	state = STATE.ATTACKING;
	can_attack = false;
	if type == AttackType.LIGHT:
		attack_anim.speed_scale = 2.0;
		hitbox.scaling = 1.0;
		attack_anim.play("fast_bite");
	elif type == AttackType.HEAVY:
		attack_anim.speed_scale = clamp(2 * heavy_attack_windup_timer, 1.0, 2.0);
		hitbox.scaling = clamp(heavy_attack_windup_timer, 0.5, 2.0);
		$Pivot/BiteSprite.scale = Vector2.ONE * clamp(2 * heavy_attack_windup_timer, 1.0, 2.0);
		attack_anim.play("heavy_bite");
		fang_anim.play("fang_jab");
		apply_impulse(
			global_position.direction_to(get_global_mouse_position()),
			150.0,
			0.2
		);

		heavy_attack_windup_timer = 0.0;
		update_fang_sprites();

		heavy_attack_cooldown_finished = false;
		get_tree().create_timer(heavy_attack_cooldown).timeout.connect(func(): heavy_attack_cooldown_finished = true);

	await attack_anim.animation_finished;
	$Pivot/BiteSprite.scale = Vector2.ONE;
	state = STATE.IDLE;

func update_fang_sprites() -> void:
	if heavy_attack_windup_timer == 0:
		print("hi");
		fang_anim.play("RESET");

	fang_sprite_l.modulate = Color.WHITE;
	fang_sprite_r.modulate = Color.WHITE;
	if heavy_attack_windup_timer == 0:
		fang_sprite_l.frame = 0;
		fang_sprite_r.frame = 0;
	elif heavy_attack_windup_timer < heavy_attack_max_windup:
		fang_sprite_l.frame = heavy_attack_windup_timer / heavy_attack_max_windup * 4;
		fang_sprite_r.frame = heavy_attack_windup_timer / heavy_attack_max_windup * 4;
	else:
		fang_sprite_l.modulate = Color.WHITE * abs(sin(5 * heavy_attack_windup_timer)) * 2;
		fang_sprite_r.modulate = Color.WHITE * abs(sin(5 * heavy_attack_windup_timer)) * 2;

func apply_impulse(direction: Vector2, magnitude: float, duration: float) -> void:
	impulse = direction * magnitude;
	get_tree().create_timer(duration).connect("timeout", func(): impulse = Vector2.ZERO);

func attack_cooldown_finished(animation: String) -> void:
	can_attack = true;

func dash_cooldown_finished() -> void:
	can_dash = true;

func projectile_cooldown_finished() -> void:
	can_shoot = true;

func dash_finished() -> void:
	dashing = false;
	dash_particles.emitting = false;
	#dash_sprite.visible = false;

func on_damage_taken(hitbox: Hitbox) -> void:
	health_manager.change_health(-hitbox.get_hit_data().damage);

func respawn() -> void:
	global_position = respawn_manager.get_closest_respawn_point().get_respawn_position();
