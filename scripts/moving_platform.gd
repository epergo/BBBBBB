class_name MovingPlatform
extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var start_animation_at: float = 0.0
@export var _paused := true


func _ready():
	animationPlayer.seek(start_animation_at)


func _process(_delta) -> void:
	animationPlayer.set_active(!_paused)


func reset() -> void:
	animationPlayer.seek(start_animation_at)
	_paused = true


func play() -> void:
	_paused = false
