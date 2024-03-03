class_name GameplayManager extends Node

@export var levelScenes: Array[PackedScene]

var currentLevelIndex: int = 0
var currentLevel: BaseLevel
var screenTransitionScene: PackedScene = preload(
	"res://scenes/UserInterface/screen_transition.tscn"
)
var levelCompleteScene: PackedScene = preload("res://scenes/UserInterface/level_complete.tscn")

var diamonds_found: int = 0
var times_player_died: int = 0

@onready var _hud: HUD = $HUD
@onready var _audio_manager: AudioManager = $"/root/AudioManagerSingleton"


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	change_level(0, false)
	_audio_manager.start_background_music()


func change_level(levelIndex: int, show_transition: bool = true) -> void:
	currentLevelIndex = levelIndex
	if currentLevelIndex >= levelScenes.size():
		currentLevelIndex = 0

	var nextLevel: BaseLevel = levelScenes[currentLevelIndex].instantiate()
	nextLevel.player_died.connect(_on_player_died)
	nextLevel.diamond_collected.connect(_on_diamond_collected)
	nextLevel.player_won.connect(_on_player_won)

	if currentLevel != null:
		currentLevel.queue_free()

	if show_transition:
		var screenTransition: ScreenTransition = screenTransitionScene.instantiate()
		add_child(screenTransition)

		await screenTransition.screen_covered

	reset_hud()

	currentLevel = nextLevel
	add_child(currentLevel)


func reset_hud() -> void:
	diamonds_found = 0
	times_player_died = 0
	_hud.update_times_dead(times_player_died)
	_hud.update_diamonds(diamonds_found)


func increment_level() -> void:
	change_level(currentLevelIndex + 1)


func get_current_level() -> BaseLevel:
	return currentLevel


func _on_player_died() -> void:
	times_player_died += 1
	_hud.update_times_dead(times_player_died)


func _on_diamond_collected() -> void:
	diamonds_found += 1
	_hud.update_diamonds(diamonds_found)


func _on_player_won() -> void:
	if currentLevel != null:
		currentLevel.remove_player()

	var levelComplete: LevelComplete = levelCompleteScene.instantiate()
	add_child(levelComplete)
	get_tree().paused = true

	await levelComplete.next_level_pressed
	get_tree().paused = false

	levelComplete.queue_free()
	increment_level()
