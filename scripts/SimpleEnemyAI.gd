class_name SimpleEnemyAI;
extends EnemyAI

@onready var player := get_tree().get_first_node_in_group("player");

@export var attack_radius := 35.0;
@export var aggro_range := 300.0;
@export var speed := 25.0;

var direction_to_player := Vector2.ZERO;
var dist_squared_to_player := 1000.0;

func _process(delta: float) -> void:
	if player.global_position.x > self.global_position.x:
		direction_to_player = global_position.direction_to(player.global_position + Vector2(-15, 0));
	else:
		direction_to_player = global_position.direction_to(player.global_position + Vector2(15, 0));
	dist_squared_to_player = global_position.distance_squared_to(player.global_position);

	if dist_squared_to_player > attack_radius * attack_radius:
		velocity = direction_to_player * speed;
		attacking = false;
	else:
		velocity = Vector2.ZERO;
		attacking = true;
