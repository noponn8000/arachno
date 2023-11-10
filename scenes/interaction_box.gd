class_name InteractionBox;
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func activate() -> void:
	anim.play("activate");

func deactivate() -> void:
	await anim.animation_finished;
	anim.play("deactivate");

func interact() -> void:
	anim.play("interact");
