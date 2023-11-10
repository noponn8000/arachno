extends CharacterBody2D

enum STATE { IDLE, CHASE, ATTACK, DAMAGE }

@onready var hurtbox := $Hurtbox;
@onready var ai := $AI;
@onready var health := $HealthManager;
@onready var dmg_numbers := $DamageNumberComponent;

@export var anim: AnimationPlayer;

var state := STATE.CHASE;

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

		move_and_slide();

	if ai.is_attacking() and state != STATE.DAMAGE:
		attack();

func on_damage_taken(hitbox: Hitbox) -> void:
	anim.play("take_damage");
	state = STATE.DAMAGE;

	dmg_numbers.spawn_number(hitbox.damage);

	health.change_health(-hitbox.damage);

	velocity = hitbox.global_position.direction_to(self.global_position) * hitbox.knockback;

	await anim.animation_finished;
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
