extends CharacterBody2D

@onready var pivot := $Pivot;
@onready var attack_anim := $Pivot/BiteSprite/AnimationPlayer;
@onready var sprite_anim := $Pivot/Legs/LegAnimationPlayer;
@onready var hurtbox := $Hurtbox;
@onready var dash_particles := $Pivot/DashParticles
@onready var health_bar := get_tree().get_first_node_in_group("health_bar");

@export var movement_speed := 100.0;
@export var acceleration := 50.0;
@export var friction := 100.0;
@export var dash_speed := 200.0;
@export var dash_cooldown := 0.8;
@export var dash_duration := 0.25;

var input_direction := Vector2.ZERO;
var can_attack := true;

# Dash
var dash_direction := Vector2.ZERO;
var can_dash := true;
var dashing := false;

enum AttackType { LIGHT, HEAVY };

func _ready() -> void:
	attack_anim.connect("animation_finished", attack_cooldown_finished);
	sprite_anim.play("move");
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
		
	if Input.is_action_pressed("dash") and can_dash:
		dash();
	
	if dashing:
		velocity = dash_direction * dash_speed;
	else:
		velocity = input_direction * movement_speed;
	move_and_slide();
	
func dash() -> void:
	if input_direction:
			dash_direction = input_direction;
	else:
		dash_direction = Vector2.ZERO;
		
	dashing = true;
	can_dash = false;
	
	dash_particles.restart();
	get_tree().create_timer(dash_duration).connect("timeout", dash_finished);
	get_tree().create_timer(dash_cooldown).connect("timeout", dash_cooldown_finished);
	
func rotate_sprite() -> void:
	pivot.look_at(get_global_mouse_position());
	pivot.rotation_degrees -= 90;
	
func animate_sprite() -> void:
	if input_direction:
		# TODO: make work for all directions
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
	
func dash_finished() -> void:
	dashing = false;
	dash_particles.emitting = false;
	
func on_damage_taken(hitbox: Hitbox) -> void:
	print("hi")
	health_bar.change_health(-hitbox.damage);
