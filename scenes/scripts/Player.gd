extends KinematicBody2D

export var bullet: PackedScene = preload("res://scenes/Bullet.tscn")
export var muzzle_flash: PackedScene = preload("res://scenes/MuzzleFlash.tscn")
var screen_size
export var speed = 400
var velocity := Vector2.ZERO
var dir := Vector2.ZERO
var weaponCoolDown = 0.75

var accel := 0.1
var deccel := 0.25

var gun_range = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Gun/CoolDownTimer.start(weaponCoolDown)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var dir_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dir_y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	if dir_x != 0 or dir_y != 0:
		velocity.y = lerp(velocity.y, dir_y * speed, accel)
		velocity.x = lerp(velocity.x, dir_x * speed, accel)
	else:
		velocity.y = lerp(velocity.y, 0, deccel)
		velocity.x = lerp(velocity.x, 0, deccel)
	velocity = velocity.clamped(speed)
	
	if velocity.length() > 0.0:
		if int(velocity.x) != 0:
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_v	= false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif int(velocity.y) != 0:
			$AnimatedSprite.animation = "up"
			$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v	= false
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.stop()

func _physics_process(delta: float) -> void:
	
	velocity = move_and_slide(velocity)

func aim():
	var all_mobs = get_tree().get_nodes_in_group("mobs")
	var target_mob = null
	var range_to_target = gun_range
	if all_mobs.size() > 0:
		for mob in all_mobs:
			mob.modulate = Color("#ffffff")
			var dist_to_mob = global_position.distance_to(mob.global_position)
			if dist_to_mob < range_to_target:
				target_mob = mob
				range_to_target = dist_to_mob
	return target_mob
	
func fire_gun():
	var inst = muzzle_flash.instance()
	inst.global_transform = $Gun/MuzzlePos.global_transform
	var direction = inst.rotation - PI / 2
	inst.rotation = direction
	get_parent().call_deferred("add_child", inst)
	
	var instance = bullet.instance()
	instance.global_transform = $Gun/BulletPos.global_transform
	get_parent().call_deferred("add_child", instance)

func begin_wave(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_PickupArea_body_entered(body):
	if body.is_in_group("Loots"):
		body.set_player(self)

func _on_CoolDownTimer_timeout():
	var target_mob = aim()
	if target_mob:
		target_mob.modulate = Color("#ac2847")
		var angle = target_mob.global_position.angle_to_point(global_position)
		get_node("Gun").transform = Transform2D(angle,Vector2.ZERO)
		fire_gun()
		$Gun/CoolDownTimer.start(weaponCoolDown) 
	else:
		get_node("Gun").transform = Transform2D(0,Vector2.ZERO)
		$Gun/CoolDownTimer.start(weaponCoolDown)
