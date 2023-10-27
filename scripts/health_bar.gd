class_name HealthBar
extends Control;

@onready var health_bar_middle = $Control/HealthBarMiddle
@onready var animation_player = $AnimationPlayer

@export var max_health := 32;
@export var animation_speed := 3.0;

var _hp := max_health;

func set_health(hp: int, animate: bool = true) -> void:
	var dx := 1.0 / float(max_health);
	_hp = hp;

	if animate:
		var tween = get_tree().create_tween();

		tween.tween_property(health_bar_middle, "region_rect:size:x", dx * _hp * 32, 1 / animation_speed);
		animation_player.play("shake");
	else:
		health_bar_middle.region_rect.size.x = dx * _hp * 32;
