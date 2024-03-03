class_name LevelComplete extends CanvasLayer

@onready var _button: Button = $PanelContainer/MarginContainer/VBoxContainer/NextLevelButton
@onready var _audio_manager: AudioManager = $"/root/AudioManagerSingleton"

signal next_level_pressed


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_button.pressed.connect(_on_next_button_pressed)

	_button.grab_focus()


func _on_next_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	_audio_manager.ui_start_playing()
	await get_tree().create_timer(0.2).timeout

	next_level_pressed.emit()
