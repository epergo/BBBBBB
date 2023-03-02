class_name Helpers
extends Node


func apply_camera_shake(percentage: float) -> void:
	var camerasInGroup := get_tree().get_nodes_in_group("camera")
	if camerasInGroup.size() > 0:
		var camera := camerasInGroup[0] as PlayerCamera
		camera.apply_shake(percentage)
