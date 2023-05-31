class_name PlayerDeath extends CharacterBody2D

var flip_h := false
var flip_v := false

@onready var sprite: Sprite2D = $Visuals/Sprite2D


func _ready() -> void:
	sprite.flip_h = flip_h
	sprite.flip_v = flip_v


func set_visual_direction(player_flip_h: bool, player_flip_v: bool) -> void:
	flip_h = player_flip_h
	flip_v = player_flip_v
