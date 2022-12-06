extends Particles2D

func _ready():
	emitting = true
	$Timer.start(lifetime * speed_scale)

func _on_Timer_timeout():
	call_deferred("queue_free")
