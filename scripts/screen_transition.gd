class_name ScreenTransition extends CanvasLayer

signal screen_covered


func emit_screen_covered() -> void:
	screen_covered.emit()
