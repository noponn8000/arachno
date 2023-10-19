extends Control

@onready var health_bar_middle = $Control/HealthBarMiddle
@onready var animation_player = $AnimationPlayer

@export var max_health := 32;
@export var animation_speed := 3.0;

var _hp := max_health;
var dx := 1.0 / float(max_health);

func set_health(hp: int, animate: bool = true) -> void:
	_hp = clamp(hp, 0, max_health);
	
	if animate:
		var tween = get_tree().create_tween();
		
		tween.tween_property(health_bar_middle, "region_rect:size:x", dx * _hp * 32, 1 / animation_speed);
		animation_player.play("shake");
	else:
		health_bar_middle.region_rect.size.x = dx * _hp * 32;
		
func get_health() -> int:
	return _hp;
	
func change_health(delta: int) -> void:
	set_health(_hp + delta);
