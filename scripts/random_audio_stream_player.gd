class_name RandomAudioStreamPlayer extends Node

@export var numberToPlay := 2
@export var enablePitchRandomization := true

@export var minPitchScale := 0.5
@export var maxPitchScale := 1.0

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func play() -> void:
	var validNodes: Array[AudioStreamPlayer] = []
	for streamPlayer: AudioStreamPlayer in get_children():
		if !streamPlayer.playing:
			validNodes.append(streamPlayer)

	for i in numberToPlay:
		if validNodes.size() == 0:
			break

		var idx := rng.randi_range(0, validNodes.size() - 1)

		if enablePitchRandomization:
			validNodes[idx].pitch_scale = rng.randf_range(minPitchScale, maxPitchScale)

		validNodes[idx].play()
		validNodes.remove_at(idx)
