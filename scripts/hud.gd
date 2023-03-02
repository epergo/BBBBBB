extends CanvasLayer
class_name HUD

@onready
var _diamondsCollected: Label = $MarginContainer/HBoxContainer/DiamondsContainer/DiamondLabel
@onready var _lifesLost: Label = $MarginContainer/HBoxContainer/LifesContainer/LifesLabel


func _ready() -> void:
	_diamondsCollected.text = str(0)
	_lifesLost.text = str(0)


func update_diamonds(new_count: int) -> void:
	_diamondsCollected.text = str(new_count)


func update_times_dead(new_times_dead: int) -> void:
	_lifesLost.text = str(new_times_dead)
