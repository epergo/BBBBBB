class_name BaseScreen extends Node2D

signal screen_checkpoint_activated
signal level_spike_damage
signal level_enemy_collision
signal level_diamond_collected
signal change_screen

var active_checkpoint: Checkpoint

@onready var _screen_area: Area2D = $ScreenArea


func _ready() -> void:
	for checkpoint in checkpoints():
		checkpoint.checkpoint_activated.connect(_on_checkpoint_activated)

	_screen_area.body_entered.connect(_on_body_entered)
	_screen_area.body_exited.connect(_on_body_exited)


func reset_moving_platforms() -> void:
	var movingPlatformsNodes := get_node("MovingPlatforms")
	if movingPlatformsNodes == null:
		return

	for platformNode in movingPlatformsNodes.get_children():
		var platform := platformNode as MovingPlatform
		platform.reset()


func checkpoints() -> Array[Checkpoint]:
	var checkpointsNodes := get_node("Checkpoints")
	if checkpointsNodes == null:
		return []

	var result: Array[Checkpoint] = []
	for checkpointNode in checkpointsNodes.get_children():
		var checkpoint: Checkpoint = checkpointNode as Checkpoint
		result.append(checkpoint)

	return result


func disable_checkpoints(all: bool) -> void:
	if all:
		active_checkpoint = null

	for checkpoint in checkpoints():
		if checkpoint != active_checkpoint:
			checkpoint.disable()


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return

	change_screen.emit(self)
	resume_moving_platforms()
	restart_disappearing_platorms()


# Look for all moving platforms in the screen and resume their movement
# They will start moving from the configured position, not 0.0
func resume_moving_platforms() -> void:
	var movingPlatformsNodes := get_node("MovingPlatforms")
	if movingPlatformsNodes == null:
		return

	for platformNode in movingPlatformsNodes.get_children():
		var platform := platformNode as MovingPlatform
		platform.play()


func restart_disappearing_platorms() -> void:
	var disappearingPlatformsNodes := get_node("DisappearingPlatforms")
	if disappearingPlatformsNodes == null:
		return

	for platformNode in disappearingPlatformsNodes.get_children():
		var platform := platformNode as DisappearingPlatform
		platform.reset()


func _on_body_exited(body: Node2D) -> void:
	if not body is Player:
		return

	reset_moving_platforms()


func _on_checkpoint_activated(checkpoint: Checkpoint) -> void:
	active_checkpoint = checkpoint
	screen_checkpoint_activated.emit(self)


func active_checkpoint_position() -> Vector2:
	if active_checkpoint == null:
		return Vector2.ZERO

	return active_checkpoint.global_position


func active_checkpoint_orientation() -> bool:
	if active_checkpoint == null:
		return false

	return !active_checkpoint.inverse()


func _on_diamond_collected() -> void:
	level_diamond_collected.emit()
