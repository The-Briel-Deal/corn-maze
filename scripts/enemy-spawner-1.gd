extends CharacterBody2D

var time_elapsed = 0
var time_elapsed_before_next_spawn = 2

func _process(delta):
	time_elapsed += delta
	if time_elapsed >= time_elapsed_before_next_spawn:
		time_elapsed -= time_elapsed_before_next_spawn
		spawn_enemy()

func spawn_enemy():
	var enemy = load("res://scenes/enemies/enemy-1.tscn").instantiate()
	enemy.position = position
	add_sibling(enemy)
