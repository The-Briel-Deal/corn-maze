extends CharacterBody2D

func _physics_process(delta):
	var target_node = get_tree().get_first_node_in_group("player")
	var speed = 10
	var target_position = target_node.global_position
	var direction = target_position - global_position
	velocity = direction.normalized() * speed
	move_and_slide()
