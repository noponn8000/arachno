class_name InteractionBox;
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
var active := true;
var oneshot := true;

func activate() -> void:
	anim.play("activate");

func deactivate() -> void:
	anim.play("deactivate");

func interact() -> void:
	active = false;
	anim.play("interact");

	if not oneshot:
		await anim.animation_finished;
		active = true;
