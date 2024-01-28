class_name MainMenu extends CanvasLayer

@onready var _playButton: Button = %PlayButton
@onready var _optionsButton: Button = %OptionsButton
@onready var _exitButton: Button = %ExitButton

@onready
var _scene_transition_manager: SceneTransitionManager = $"/root/SceneTransitionManagerSingleton"


func _ready() -> void:
	_playButton.pressed.connect(_on_play_pressed)
	_optionsButton.pressed.connect(_on_options_pressed)
	_exitButton.pressed.connect(_on_exit_pressed)

	_playButton.grab_focus()


func _on_play_pressed() -> void:
	_scene_transition_manager.first_level()


func _on_options_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
