extends Shakable;

@export_range(0, 3) var type := 0;
@export var randomise := false;

@onready var leaves: Sprite2D = $Leaves
@onready var roots: Sprite2D = $Roots;

func _ready() -> void:
	if randomise:
		type = randi_range(0, 3);

	roots.frame = type;
	leaves.frame = type;

	sprite = leaves;
	particles = $GPUParticles2D;

	$Area2D.body_entered.connect(on_body_entered);
	$Area2D.body_exited.connect(on_body_exited);
	$Area2D.area_entered.connect(on_area_entered);

func on_body_entered(body: Node2D) -> void:
	animate_shake(30.0, 1.3, 0.95);

	if body is Player:
		Global.player.concealed = true;

func on_area_entered(other: Area2D) -> void:
	if other is Hitbox and other.monitoring:
		animate_shake(30.0, 1.3, 0.95);

func on_body_exited(body: Node2D) -> void:
	if body is Player:
		Global.player.concealed = false;
