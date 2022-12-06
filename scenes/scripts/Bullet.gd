extends KinematicBody2D

var speed := 800.0
var velocity := Vector2.ZERO

func _ready() -> void:
	velocity = transform.x * speed
	
func _physics_process(delta: float) -> void:
	
	var collision = move_and_collide(velocity * delta)
	if !collision: return
	if collision.collider.is_in_group("mobs"):
		collision.collider.die()
	explode()

func explode():
	call_deferred("queue_free")
