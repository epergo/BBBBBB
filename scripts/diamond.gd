class_name Diamond extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $AnimatedSprite2D/Area2D
@onready var shape: CollisionShape2D = $AnimatedSprite2D/Area2D/CollisionShape2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	area.area_entered.connect(_on_area_entered)

func _on_area_entered(_area2d: Area2D) -> void:
	shape.call_deferred("set_disabled", true)
	animation_player.play("pickup")
	audio_player.play()
