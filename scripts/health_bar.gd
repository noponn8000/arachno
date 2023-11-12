class_name HealthBar
extends Control;

@onready var health_bar_middle = $Control/HealthBarMiddle
@onready var animation_player = $AnimationPlayer
@onready var area := $Area2D;
@onready var label := $Label;

@export var max_health := 32;
@export var animation_speed := 3.0;

var _hp := max_health;

func _ready() -> void:
	area.mouse_entered.connect(entered);
	area.mouse_exited.connect(exited);

func set_health(hp: int, animate: bool = true) -> void:
	var dx := 1.0 / float(max_health);
	_hp = hp;

	label.text = str(_hp) + " / " + str(max_health);

	if animate:
		var tween = get_tree().create_tween();

		tween.tween_property(health_bar_middle, "region_rect:size:x", dx * _hp * 32, 1 / animation_speed);
		animation_player.play("shake");
	else:
		health_bar_middle.region_rect.size.x = dx * _hp * 32;

func entered() -> void:
	print("entered");
	label.visible = true;

func exited() -> void:
	print("exited");
	label.visible = false;
