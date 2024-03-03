class_name MainMenu extends CanvasLayer

@onready var _playButton: Button = %PlayButton
@onready var _exitButton: Button = %ExitButton

@onready
var _scene_transition_manager: SceneTransitionManager = $"/root/SceneTransitionManagerSingleton"

@onready var _audio_manager: AudioManager = $"/root/AudioManagerSingleton"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_audio_manager.stop_background_music()

	_playButton.pressed.connect(_on_play_pressed)
	_exitButton.pressed.connect(_on_exit_pressed)

	_playButton.grab_focus()

	# Play sound when changing focus
	_playButton.focus_entered.connect(_audio_manager.ui_change_focused_button)
	_exitButton.focus_entered.connect(_audio_manager.ui_change_focused_button)

func _on_play_pressed() -> void:
	_audio_manager.ui_start_playing()
	await get_tree().create_timer(0.2).timeout

	_scene_transition_manager.first_level()

func _on_exit_pressed() -> void:
	_audio_manager.ui_back()
	await get_tree().create_timer(0.2).timeout

	get_tree().quit()
