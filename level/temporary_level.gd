extends Node3D

var player_score = 0

@onready var label = %Label


func increase_score():
	player_score += 1
	label.text = "score: " + str(player_score)

func _on_mob_spawner_3d_mob_spawned(_mob):
	_mob.died.connect(func on_mob_died():
		increase_score()
		do_poof(_mob.global_position)
		)
	do_poof(_mob.global_position)


func do_poof(_mob_global_position):
	const _SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var _poof = _SMOKE_PUFF.instantiate()
	add_child(_poof)
	_poof.global_position = _mob_global_position

func _on_kill_plane_body_entered(_body):
	get_tree().reload_current_scene()
