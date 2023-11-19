class_name DisappearingPlatform extends CharacterBody2D

@export var animatedSprite_nodepath: NodePath
@export var collisions_nodepath: NodePath

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisions: CollisionShape2D = $CollisionShape2D


func disappear() -> void:
	animatedSprite.play()


func _on_animation_finished() -> void:
	set_visible(false)
	animatedSprite.stop()
	collisions.set_deferred("disabled", true)


func reset() -> void:
	if animatedSprite.is_playing():
		animatedSprite.stop()

	set_visible(true)
	collisions.set_deferred("disabled", false)
	animatedSprite.set_frame(0)
