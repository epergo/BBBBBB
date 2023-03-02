extends Node2D
class_name Checkpoint

signal checkpoint_activated

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

@export var active: bool = false


func _ready() -> void:
	if active:
		animatedSprite.play("checked")
	else:
		animatedSprite.play("unchecked")

	area.connect("body_entered", Callable(self, "_on_player_entered"))


func _on_player_entered(body: Node2D) -> void:
	# Collision with something that is not a player, do nothing
	if not body is Player:
		return

	# Checkpoint already active, do nothing
	if active:
		return

	active = true
	animatedSprite.play("turn_on")
	emit_signal("checkpoint_activated", self)


func disable() -> void:
	if not active:
		return

	active = false
	animatedSprite.play("turn_off")


func inverse() -> bool:
	var rotationDegress := rad_to_deg(rotation)
	return abs(rotationDegress) > 160
