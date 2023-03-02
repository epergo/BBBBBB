class_name PauseMenu
extends CanvasLayer

@onready
var _continueButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
@onready
var _optionsButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
@onready
var _quitButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

@onready var _scene_transition_manager: SceneTransitionManager = $"/root/SceneTransitionManagerSingleton"


func _ready() -> void:
	_continueButton.connect("pressed", Callable(self, "_on_continue_pressed"))
	_optionsButton.connect("pressed", Callable(self, "_on_options_pressed"))
	_quitButton.connect("pressed", Callable(self, "_on_quit_pressed"))
	get_tree().paused = true


func unpause() -> void:
	queue_free()
	get_tree().paused = false


func _on_continue_pressed() -> void:
	unpause()


func _on_options_pressed() -> void:
	# TODO Options menu
	pass


func _on_quit_pressed() -> void:
	_scene_transition_manager.transition_to_menu()
	unpause()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()
		get_viewport().set_input_as_handled()
