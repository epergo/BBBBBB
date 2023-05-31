class_name SceneTransitionManager extends Node

var screenTransitionScene: PackedScene = preload(
	"res://scenes/UserInterface/screen_transition.tscn"
)


func transition_to_scene(scenePath: String) -> void:
	var screenTransition: ScreenTransition = screenTransitionScene.instantiate()
	add_child(screenTransition)

	await screenTransition.screen_covered

	get_tree().change_scene_to_file(scenePath)


func first_level() -> void:
	transition_to_scene("res://scenes/utils/gameplay_manager.tscn")


func transition_to_menu() -> void:
	transition_to_scene("res://scenes/UserInterface/main_menu.tscn")
