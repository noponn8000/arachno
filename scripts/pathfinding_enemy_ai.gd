class_name PathfindingEnemyAI
extends SimpleEnemyAI

enum AI_STATE {CHASING, SEARCHING};

@export var nav_agent: NavigationAgent2D = get_child(0);

@onready var timer := Timer.new();

var state := AI_STATE.CHASING;

func _ready() -> void:
	timer.connect("timeout", update_target_position);
	update_target_position();

	add_child(timer);

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
	timer.start(0.1);

func search() -> void:
	await get_tree().create_timer(2.0).timeout;
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * speed;
