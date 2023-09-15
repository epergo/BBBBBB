class_name BaseLevel extends Node

@onready var _screensNode: Node2D = $Screens
@onready var _camera: PlayerCamera = $Camera2D
@onready var _playerRoot: Node2D = $PlayerRoot
@onready var _player: Player = $PlayerRoot/Player
@onready var _flag: Flag = $Flag

var _pauseMenuScene: PackedScene = preload("res://scenes/UserInterface/pause_menu.tscn")

signal player_died
signal player_won
signal diamond_collected

var spawnPosition: Vector2 = Vector2.ZERO
var level_checkpoint: BaseScreen
var spawnOrientation: bool = false
var playerScene: PackedScene = preload("res://scenes/player.tscn")


func _ready():
	for screen in get_screens():
		screen.change_screen.connect(_on_change_screen)
		screen.screen_checkpoint_activated.connect(_on_handle_screen_checkpoint_activated)

	var screens: Array[BaseScreen] = get_screens()
	if screens.size() > 0:
		level_checkpoint = screens[0]

	_flag.player_won.connect(_on_player_won)

	register_player(_player)

	spawnPosition = _player.global_position
	spawnOrientation = _player.going_down


func register_player(player) -> void:
	_player = player
	_player.died.connect(_on_player_died, CONNECT_DEFERRED)
	_player.diamond_collected.connect(_on_diamond_collected, CONNECT_DEFERRED)
	_player.DEBUG_go_to_prev_checkpoint.connect(_go_to_prev_checkpoint)


func create_player() -> void:
	var playerInstance: Player = playerScene.instantiate()
	playerInstance.going_down = spawnOrientation
	playerInstance.global_position = spawnPosition
	_playerRoot.add_child(playerInstance)
	register_player(playerInstance)


func _go_to_prev_checkpoint() -> void:
	_player.queue_free()

	await get_tree().create_timer(1.0).timeout

	create_player()

	_on_change_screen(level_checkpoint)


func get_screens() -> Array[BaseScreen]:
	var screens: Array[BaseScreen] = []
	for screenNode in _screensNode.get_children():
		var screen := screenNode as BaseScreen
		screens.push_back(screen)

	return screens


func remove_player() -> void:
	if _player == null:
		return

	_player.queue_free()


func _on_change_screen(level: BaseScreen) -> void:
	_camera.change_screen(level.global_position)


func _on_player_died() -> void:
	_go_to_prev_checkpoint()
	player_died.emit()


func _on_handle_screen_checkpoint_activated(level: BaseScreen) -> void:
	var disable_all: bool = level != level_checkpoint
	if level_checkpoint != null:
		# We already had a checkpoint active, disable
		level_checkpoint.disable_checkpoints(disable_all)

	level_checkpoint = level
	spawnOrientation = level.active_checkpoint_orientation()
	var padding := Vector2(0, 0)
	if !spawnOrientation:
		padding.y += 12

	spawnPosition = level.active_checkpoint_position() + padding


func _on_diamond_collected() -> void:
	diamond_collected.emit()


func _on_player_won() -> void:
	player_won.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pauseMenu: PauseMenu = _pauseMenuScene.instantiate()
		add_child(pauseMenu)
