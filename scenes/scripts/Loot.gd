extends KinematicBody2D

var speed := 600.0
var player = null
var accel := 0.1
var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if !player: return
	look_at(player.global_position)
	var dir = (player.global_position - global_position).normalized()
	velocity = lerp(velocity, speed * dir, accel)
	var collision = move_and_collide(velocity * delta)
	if collision:
		collect_loot()
	
	
func set_player(p):
	player = p
	
func collect_loot():
	get_parent().call("add_loot")
	call_deferred("queue_free")
