class_name PlayerCamera extends Camera2D

var targetPosition := Vector2.ZERO

@export var backgroundColor: Color
@export var shakeNoise: FastNoiseLite

var xNoiseSampleVector := Vector2.RIGHT
var yNoiseSampleVector := Vector2.DOWN

var xNoiseSamplePosition := Vector2.ZERO
var yNoiseSamplePosition := Vector2.ZERO

var noiseSampleTravelRate := 500  # Pixels per second
var maxShakeOff := 6
var currentShakePercentage := 0.0
var shakeDecay := 4


func _ready() -> void:
	RenderingServer.set_default_clear_color(backgroundColor)


func _process(delta: float) -> void:
	if currentShakePercentage > 0:
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample := shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample := shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)

		offset = Vector2(xSample, ySample) * maxShakeOff * pow(currentShakePercentage, 2)

		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)


func apply_shake(percentage: float) -> void:
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)


func change_screen(screen_pos: Vector2) -> void:
	position = screen_pos
