class_name HealthManager;
extends Node;

@export var health_bar: HealthBar;

@export var max_health := 100;
@export var hp := max_health;

signal health_changed (int);
signal health_depleted;

func _ready() -> void:
	if health_bar:
		await health_bar.ready;

		health_bar.max_health = max_health;
		health_bar.set_health(hp);

		connect("health_changed", health_bar.set_health);

func set_health(new_value: int) -> void:
	hp = clamp(new_value, 0, max_health);

	if (hp == 0):
		emit_signal("health_depleted");
	else:
		emit_signal("health_changed", hp);

func get_health() -> int:
	return hp;

func change_health(delta: int) -> void:
	set_health(hp + delta);
