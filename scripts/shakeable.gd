class_name Shakable;
extends Node2D;

@export var sprite: Sprite2D;
@onready var particles: GPUParticles2D;

var shake_amplitude := 0.0;
var shake_speed := 0.0;
var shake_offset := 0.0;
var shake_damping := 0.0;
var shake_timer := 0.0;
var shaking := false;

func _physics_process(delta: float) -> void:
	if not shaking:
		return;

	if abs(shake_speed) < 1.0:
		shaking = false;
		shake_offset = move_toward(shake_offset, 0.0, 0.5);

	shake_offset += shake_speed * delta;

	if abs(shake_offset) > shake_amplitude:
		shake_speed = -shake_speed;

	sprite.material.set_shader_parameter("deformation", shake_offset);
	shake_speed *= pow(shake_damping, 1.0 + shake_timer);
	shake_timer += delta;

func animate_shake(speed: float, amplitude: float, damping: float) -> void:
	particles.restart();

	shake_offset = 0.0;
	shake_amplitude = amplitude;
	shake_speed = speed;
	shake_damping = damping;
	shake_timer = 0.0;

	shaking = true;
