class_name Flag extends Node2D

signal player_won

@onready var area: Area2D = $Area2D


func _ready() -> void:
	area.area_entered.connect(_on_handle_area_entered)


func _on_handle_area_entered(_area2d: Area2D) -> void:
	area.disconnect("area_entered", Callable(self, "_on_handle_area_entered"))
	player_won.emit()
