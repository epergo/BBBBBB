class_name PauseMenu
extends CanvasLayer

@onready
var _continueButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
@onready
var _quitButton: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MainMenuButton

@onready
var _scene_transition_manager: SceneTransitionManager = $"/root/SceneTransitionManagerSingleton"
@onready var _audio_manager: AudioManager = $"/root/AudioManagerSingleton"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_continueButton.pressed.connect(_on_continue_pressed)
	_quitButton.pressed.connect(_on_quit_pressed)

	_continueButton.grab_focus()

	# Play sound when changing focus
	_continueButton.focus_entered.connect(_audio_manager.ui_change_focused_button)
	_quitButton.focus_entered.connect(_audio_manager.ui_change_focused_button)

	get_tree().paused = true

func unpause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	queue_free()
	get_tree().paused = false

func _on_continue_pressed() -> void:
	_audio_manager.ui_continue()
	await get_tree().create_timer(0.2).timeout

	unpause()

func _on_quit_pressed() -> void:
	_audio_manager.ui_back()
	await get_tree().create_timer(0.2).timeout

	_scene_transition_manager.transition_to_menu()
	unpause()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()
		get_viewport().set_input_as_handled()
