extends CharacterBody2D

enum STATE { IDLE, CHASE, ATTACK, DAMAGE }

@onready var hurtbox := $Hurtbox;
@onready var player := get_tree().get_first_node_in_group("player");

@export var anim: AnimationPlayer;
@export var max_hp := 100.0;
@export var speed := 25.0;
@export var attack_radius := 30.0;
@export var aggro_range := 1000.0;

var hp := max_hp;
var direction_to_player := Vector2.ZERO;
var distance_to_player := 1000.0;

var state := STATE.CHASE;

func _ready() -> void:
	hurtbox.connect("damage_taken", on_damage_taken);
	
func _physics_process(delta: float) -> void:
	if player:
		if state == STATE.CHASE:
			if player.global_position.x > self.global_position.x:
				direction_to_player = global_position.direction_to(player.global_position + Vector2(-30, 0));
			else:
				direction_to_player = global_position.direction_to(player.global_position + Vector2(30, 0));
			velocity = direction_to_player * speed;
		else:
			velocity = velocity.move_toward(Vector2.ZERO, 1.0);
		
		distance_to_player = global_position.distance_to(player.global_position);
		if state == STATE.IDLE and distance_to_player <= aggro_range:
			state = STATE.CHASE;
		if distance_to_player <= attack_radius and state != STATE.ATTACK and state != STATE.DAMAGE:
			attack();
	
		move_and_slide();
	
func on_damage_taken(hitbox: Hitbox) -> void:
	hp -= hitbox.damage;
	anim.play("take_damage");
	state = STATE.DAMAGE;
	
	if hp < 0:
		hp = 0;
		die();
		
	velocity = hitbox.global_position.direction_to(self.global_position) * hitbox.knockback;
		
	await anim.animation_finished;
	state = STATE.IDLE;
	anim.play("idle");
			
func attack() -> void:
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
