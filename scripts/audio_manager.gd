class_name AudioManager extends Node

@onready var _background: AudioStreamPlayer = %BackgroundMusic
@onready var _button_focus: AudioStreamPlayer = %ButtonFocusChange
@onready var _start_playing: AudioStreamPlayer = %StartPlaying
@onready var _back: AudioStreamPlayer = %Back
@onready var _continue: AudioStreamPlayer = %Continue

func start_background_music() -> void:
	_background.play()

func stop_background_music() -> void:
	_background.stop()

func ui_start_playing() -> void:
	_start_playing.play()

func ui_continue() -> void:
	_continue.play()

func ui_next_level() -> void:
	_continue.play()

func ui_back() -> void:
	_back.play()

func ui_change_focused_button() -> void:
	_button_focus.play()
