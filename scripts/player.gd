class_name Player extends CharacterBody2D

const SPRITE_SIZE := 24

@onready var hazardArea: Area2D = $HazardArea
@onready var enemiesArea: Area2D = $EnemiesArea
@onready var collectablesArea: Area2D = $CollectablesArea
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyoteTimer: Timer = $CoyoteTimer
@onready var dashParticles: CPUParticles2D = $DashParticles

@onready var _helpers: Helpers = $"/root/Helper"

var playerDeathScene := preload("res://scenes/player_death.tscn")
var footstepParticles := preload("res://scenes/footsteps_particles.tscn")

signal DEBUG_go_to_prev_checkpoint
signal died
signal diamond_collected

var speed := Vector2(200.0, 350.0)
var _velocity := Vector2.ZERO

var isDead := false
var isNewState := true

# going_down tells me the direction the character will *fall*
@export var going_down := true


func _ready() -> void:
	hazardArea.area_entered.connect(_on_hazard_area_entered)
	enemiesArea.area_entered.connect(_on_hazard_area_entered)
	collectablesArea.area_entered.connect(_on_collectables_area_entered)


func _physics_process(_delta: float) -> void:
	if (
		(is_on_floor() || !coyoteTimer.is_stopped())
		&& Input.is_action_just_pressed("change_gravity")
	):
		going_down = !going_down

	var direction := get_direction()

	_velocity = calculate_move_velocity(_velocity, direction)

	var was_on_floor := is_on_floor()
	set_velocity(_velocity)
	set_up_direction(where_is_up())
	move_and_slide()
	_velocity = velocity

	if was_on_floor && !is_on_floor():
		coyoteTimer.start()

	if !was_on_floor && is_on_floor() && !isNewState:
		emit_footstep_particles()

	var slide_count := get_slide_collision_count()
	if slide_count:
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var colliderObject := collision.get_collider()
			if colliderObject is DisappearingPlatform:
				var collider: DisappearingPlatform = colliderObject
				collider.disappear()

	if Input.is_action_just_pressed("DEBUG_go_to_prev_checkpoint"):
		DEBUG_go_to_prev_checkpoint.emit()

	update_animation()

	# Don't consider that `new state` state has finished until the player
	# touches the ground the first time
	if isNewState && is_on_floor():
		isNewState = false


func where_is_up() -> Vector2:
	var direction := Vector2.ZERO
	if going_down:
		direction.y = -1
	else:
		direction.y = 1

	return direction


func get_direction() -> Vector2:
	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y: int
	if going_down:
		y = 1
	else:
		y = -1

	return Vector2(x, y)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2) -> Vector2:
	var newVelocity := linear_velocity
	newVelocity.x = speed.x * direction.x
	if direction.y != 0.0:
		newVelocity.y = lerp(newVelocity.y, speed.y * direction.y, 0.3)

	return newVelocity


func update_animation() -> void:
	if abs(velocity.y) > 0:
		animatedSprite.play("fall")
	elif abs(velocity.x) > 0:
		animatedSprite.play("run")
	else:
		animatedSprite.play("idle")

	if velocity.x != 0:
		animatedSprite.flip_h = velocity.x > 0

	animatedSprite.flip_v = !going_down
	dashParticles.emitting = !is_on_floor()


func die() -> void:
	if isDead:
		return

	isDead = true
	died.emit()
	die_effect()
	respawn()


func die_effect() -> void:
	_helpers.apply_camera_shake(1.0)


func respawn() -> void:
	var playerDeathInstance := playerDeathScene.instantiate() as PlayerDeath
	playerDeathInstance.global_position = global_position
	playerDeathInstance.set_visual_direction(animatedSprite.flip_h, animatedSprite.flip_v)

	add_sibling(playerDeathInstance)


func emit_footstep_particles() -> void:
	var particlesInstance := footstepParticles.instantiate() as Node2D
	var padding := Vector2(0, 0)
	if !going_down:
		padding = Vector2(0, -SPRITE_SIZE)

	particlesInstance.global_position = global_position + padding
	add_sibling(particlesInstance)


func _on_hazard_area_entered(_body: Area2D) -> void:
	call_deferred("die")


func _on_collectables_area_entered(_diamond: Diamond) -> void:
	diamond_collected.emit()
