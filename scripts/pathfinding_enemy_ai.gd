class_name PathfindingEnemyAI
extends SimpleEnemyAI

enum AI_STATE {CHASING, SEARCHING};

@export var nav_agent: NavigationAgent2D;

var state := AI_STATE.CHASING;

func _ready() -> void:
	update_target_position();

func _physics_process(delta: float) -> void:
	if Global.player.concealed:
		velocity = Vector2.ZERO;
		state = AI_STATE.SEARCHING;
	else:
		state = AI_STATE.CHASING;
		update_target_position();

		direction_to_player = global_position.direction_to(nav_agent.get_next_path_position());
		dist_squared_to_player = global_position.distance_squared_to(player.global_position);

		update_attack();

		if not attacking:
			velocity = direction_to_player * speed;

func update_target_position() -> void:
	nav_agent.target_position = player.global_position;
	get_tree().create_timer(0.2).timeout.connect(update_target_position);

func search() -> void:
	await get_tree().create_timer(2.0).timeout;
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * speed;
