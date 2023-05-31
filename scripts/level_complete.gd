class_name LevelComplete extends CanvasLayer

@onready var _button: Button = $PanelContainer/MarginContainer/VBoxContainer/NextLevelButton

signal next_level_pressed


func _ready() -> void:
	_button.pressed.connect(_on_next_button_pressed)


func _on_next_button_pressed() -> void:
	emit_signal("next_level_pressed")
