extends Node2D

@export_range(0, 3) var type := 0;
@export var randomise := false;

@onready var roots: Sprite2D = $Roots
@onready var leaves: Sprite2D = $Leaves
@onready var particles := $GPUParticles2D;

var shake_amplitude := 0.0;
var shake_speed := 0.0;
var shake_offset := 0.0;
var shake_damping := 0.0;
var shake_timer := 0.0;
var shaking := false;

func _ready() -> void:
	if randomise:
		type = randi_range(0, 3);

	roots.frame = type;
	leaves.frame = type;

	$Area2D.body_entered.connect(on_body_entered);
	$Area2D.body_exited.connect(on_body_exited);
	$Area2D.area_entered.connect(on_area_entered);

func _physics_process(delta: float) -> void:
	if not shaking:
		return;

	if abs(shake_speed) < 1.0:
		shaking = false;
		shake_offset = move_toward(shake_offset, 0.0, 0.5);

	shake_offset += shake_speed * delta;

	if abs(shake_offset) > shake_amplitude:
		shake_speed = -shake_speed;

	leaves.material.set_shader_parameter("deformation", shake_offset);
	shake_speed *= pow(shake_damping, 1.0 + shake_timer);
	shake_timer += delta;
	#shake_amplitude *= 1.0 - (shake_damping * delta)

func animate_shake(speed: float, amplitude: float, damping: float) -> void:
	particles.restart();

	shake_offset = 0.0;
	shake_amplitude = amplitude;
	shake_speed = speed;
	shake_damping = damping;
	shake_timer = 0.0;

	shaking = true;

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
