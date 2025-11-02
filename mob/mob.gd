extends RigidBody3D

signal died

var health = 3

var speed = randf_range(2.0, 4.0)

@onready var hurt_sound: AudioStreamPlayer3D = %HurtSound
@onready var ko_sound: AudioStreamPlayer3D = %KOSound


@onready var bat_model: = %bat_model
@onready var timer: Timer = %Timer

@onready var player = get_node("/root/TemporaryLevel/Player")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)


func take_damage():
	if health == 0:
		return

	bat_model.hurt()
	health -= 1
	hurt_sound.play()
	
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var _direction = -1.0 * global_position.direction_to(player.global_position)
		var _random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		apply_central_impulse(_direction * 10.0 + _random_upward_force)
		timer.start()
		ko_sound.play()


func _on_timer_timeout():
	queue_free()
	died.emit()
