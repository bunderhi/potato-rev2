extends KinematicBody2D

export(PackedScene) var loot_scene

var speed := 150.0
var player = null
var accel := 0.1
var velocity := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	speed += rand_range(-50, 50)
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _physics_process(delta: float) -> void:
	if !player: return
	look_at(player.global_position)
	var dir = (player.global_position - global_position).normalized()
	velocity = lerp(velocity, speed * dir, accel)
	velocity = move_and_slide(velocity)
	

func set_player(p):
	player = p
	
func die():
	get_parent().call("add_kill")
	call_deferred("spawn_loot")
	call_deferred("queue_free")
	
func spawn_loot():
	var loot = loot_scene.instance()
	loot.position = position
	get_parent().call_deferred("add_child", loot)
