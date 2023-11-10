class_name SimpleEnemyAI;
extends EnemyAI

@onready var player := get_tree().get_first_node_in_group("player");

@export var attack_radius := 35.0;
@export var aggro_range := 300.0;
@export var speed := 25.0;
@export var offset := Vector2(15, 0);

var direction_to_player := Vector2.ZERO;
var dist_squared_to_player := 1000.0;

func _physics_process(delta: float) -> void:
	if player.global_position.x > self.global_position.x:
		direction_to_player = global_position.direction_to(player.global_position + -offset);
	else:
		direction_to_player = global_position.direction_to(player.global_position + offset);
	dist_squared_to_player = global_position.distance_squared_to(player.global_position);

	update_attack();

	if not attacking:
		velocity = direction_to_player * speed;

func update_attack() -> void:
	if dist_squared_to_player > attack_radius * attack_radius:
		attacking = false;
	else:
		velocity = Vector2.ZERO;
		attacking = true;
