class_name DisappearingPlatform extends CharacterBody2D

@export var animatedSprite_nodepath: NodePath
@export var collisions_nodepath: NodePath

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisions: CollisionShape2D = $CollisionShape2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var is_dissapearing := false


func disappear() -> void:
	if is_dissapearing:
		return

	animatedSprite.play()
	audio_player.play()
	is_dissapearing = true


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
	is_dissapearing = false
