extends Node2D

@export var light_particle: PackedScene;
@export var emitting := false;
@export var emit_interval := 1.5;
@export var color := Color.WHITE;
@export var intensity := 0.5;

var particles := [];
var can_emit := true;

func _process(delta: float) -> void:
	if emitting and can_emit:
		can_emit = false;
		
		var new_particle = light_particle.instantiate();
		particles.append(new_particle);
		get_tree().root.add_child(new_particle);
		
		new_particle.global_position = global_position;
		new_particle.rotation_degrees = randf_range(-180, 180);
		new_particle.texture_scale = randf_range(0.05, 0.15);
		new_particle.speed = randi_range(5, 15);
		new_particle.color = color;
		new_particle.energy = intensity;
		
		get_tree().create_timer(emit_interval).connect("timeout", on_emit_interval_timeout);

func on_emit_interval_timeout() -> void:
	can_emit = true;
