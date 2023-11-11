extends CharacterBody2D

enum STATE { IDLE, CHASE, ATTACK, DAMAGE }

@onready var hurtbox := $Hurtbox;
@onready var ai := $AI;
@onready var health := $HealthManager;
@onready var dmg_numbers := $DamageNumberComponent;

@export var anim: AnimationPlayer;

var state := STATE.CHASE;
var impulse := Vector2.ZERO;

func _ready() -> void:
	hurtbox.connect("damage_taken", on_damage_taken);
	health.connect("health_depleted", die);

func _physics_process(delta: float) -> void:
	if state == STATE.CHASE or state == STATE.IDLE:
		velocity = ai.get_velocity();

		if velocity != Vector2.ZERO:
			state = STATE.CHASE;
		else:
			state = STATE.IDLE;
	else:
		velocity = impulse;

	move_and_slide();

	if ai.is_attacking() and state != STATE.DAMAGE:
		attack();

func on_damage_taken(hitbox: Hitbox) -> void:
	anim.play("take_damage");
	state = STATE.DAMAGE;

	var hit_data = hitbox.get_hit_data();
	dmg_numbers.spawn_number(hit_data.damage, hit_data.critical);

	health.change_health(-hit_data.damage);

	apply_impulse(hit_data.origin.direction_to(self.global_position), hit_data.knockback, 0.2);

	# Scale the hurt animation with the stun time of the hit
	anim.speed_scale = 1.0 / hit_data.stun_time;
	# Wait until the animation is over and return to idle statie
	# Also reset the anim's speed scale to the normal value
	await anim.animation_finished;
	anim.speed_scale = 1.0
	state = STATE.IDLE;
	anim.play("idle");

func attack() -> void:
	if anim.current_animation == "attack":
		return;

	state = STATE.ATTACK;
	anim.play("attack");

	await anim.animation_finished;
	state = STATE.IDLE;
	anim.play("idle");

func die() -> void:
	var tween = get_tree().create_tween();

	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5);

	await tween.finished;
	queue_free();

func apply_impulse(direction: Vector2, magnitude: float, duration: float) -> void:
	impulse = direction * magnitude;
	get_tree().create_timer(duration).connect("timeout", func(): impulse = Vector2.ZERO);
