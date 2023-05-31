class_name MainMenu extends CanvasLayer

@onready
var _playButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
@onready
var _optionsButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
@onready
var _exitButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ExitButton

@onready
var _scene_transition_manager: SceneTransitionManager = $"/root/SceneTransitionManagerSingleton"


func _ready() -> void:
	_playButton.pressed.connect(_on_play_pressed)
	_optionsButton.pressed.connect(_on_options_pressed)
	_exitButton.pressed.connect(_on_exit_pressed)


func _on_play_pressed() -> void:
	_scene_transition_manager.first_level()


func _on_options_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()
