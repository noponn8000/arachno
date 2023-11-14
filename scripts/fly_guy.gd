extends CharacterBody2D

@export var charge_speed := 100.0;
@export var charge_duration := 1.0;
@export var charge_range := 70.0;

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var ai: Node2D = $PathfindingEnemyAI
@onready var hurtbox := $Hurtbox;
@onready var health := $HealthManager;
@onready var dmg_numbers := $DamageNumberComponent;

var state := STATE.CHASE;
var impulse := Vector2.ZERO;
var charging := false;
var flipped := false;

enum STATE { IDLE, CHASE, ATTACK, DAMAGE }

func _ready() -> void:
	hurtbox.connect("damage_taken", on_damage_taken);
	health.connect("health_depleted", die);

	anim.play("fly");

func _physics_process(_delta: float) -> void:
	if state == STATE.CHASE or state == STATE.IDLE:

		if not charging:
			update_sprite_direction;

			velocity = ai.get_velocity();

			if velocity != Vector2.ZERO:
				state = STATE.CHASE;
			else:
				state = STATE.IDLE;
	elif state == STATE.DAMAGE:
		velocity = impulse;

	move_and_slide();

	if ai.is_attacking() and state != STATE.DAMAGE:
		attack();
	elif (
		global_position.distance_to(Global.player.global_position) < charge_range
		and state != STATE.DAMAGE and state != STATE.ATTACK
	):
		charge();

	if get_slide_collision_count() > 0 and charging:
		charging = false;
		velocity = Vector2.ZERO;
		anim.play("fly");

func on_damage_taken(hitbox: Hitbox) -> void:
	anim.play("take_damage");
	state = STATE.DAMAGE;
	charging = false;

	var hit_data = hitbox.get_hit_data();
	dmg_numbers.spawn_number(hit_data.damage, hit_data.critical);

	health.change_health(-hit_data.damage);

	apply_impulse(hit_data.origin.direction_to(self.global_position), hit_data.knockback, 0.2);

	# Scale the hurt animation with the stun time of the hit
	anim.speed_scale = 1.0 / hit_data.stun_time;
	# Wait until the animation is over and return to idle statie
	# Also reset the anim's speed scale to the normal value
	await anim.animation_finished;
	anim.speed_scale = 2.0
	state = STATE.IDLE;
	anim.play("fly");

func attack() -> void:
	if anim.current_animation == "bite" or anim.current_animation == "bite_flipped":
		return;

	state = STATE.ATTACK;

	# Drift away from player
	velocity = Vector2.ZERO;
	anim.play("fly");
	var tween = get_tree().create_tween();
	tween.tween_property(
		self,
		"global_position",
		global_position - (ai.direction_to_player * 10),
		0.5
	);

	await tween.finished;

	tween = get_tree().create_tween();
	tween.tween_property(
		self,
		"global_position",
		global_position + (ai.direction_to_player * min(50, global_position.distance_to(Global.player.global_position))),
		0.5
	);

	if ai.direction_to_player.x >= 0:
		anim.play("bite");
		flip_h(false);
	else:
		anim.play("bite_flipped");
		flip_h(true);

	await anim.animation_finished;

	velocity = Vector2.ZERO;
	state = STATE.CHASE;

	anim.play("fly");

func charge() -> void:
	if charging:
		return;

	charging = true;
	velocity = Vector2.ZERO;
	await get_tree().create_timer(0.5).timeout;
	update_sprite_direction();

	velocity = ai.direction_to_player * charge_speed;
	if not flipped:
		anim.play("attack");
	else:
		anim.play("attack_flipped");

	get_tree().create_timer(charge_duration).timeout.connect(
		func() : charging = false; velocity = Vector2.ZERO; anim.play("fly"); state = STATE.IDLE
	);

func die() -> void:
	var tween = get_tree().create_tween();

	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5);

	await tween.finished;
	queue_free();

func apply_impulse(direction: Vector2, magnitude: float, duration: float) -> void:
	impulse = direction * magnitude;
	get_tree().create_timer(duration).connect("timeout", func(): impulse = Vector2.ZERO);

func flip_h(reverse: bool) -> void:
	if reverse:
		for sprite in $Sprites.get_children():
			sprite.flip_h = true;

		flipped = true;
	else:
		for sprite in $Sprites.get_children():
			sprite.flip_h = false;

		flipped = false;

func update_sprite_direction() -> void:
	if ai.direction_to_player.x > 0:
				flip_h(false);
	else:
		flip_h(true);
