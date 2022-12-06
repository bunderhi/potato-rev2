extends Node2D

export(PackedScene) var mob_scene
var kills 
var money

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	new_game()


func new_game():
	$Player.begin_wave($StartPosition.position)
	$WaveTimer.start(60)
	kills = 0
	money = 0
	
func _process(delta):
	$HUD/WaveTimerLabel.text = str(int($WaveTimer.get_time_left()))
	$HUD/KillsLabel.text = str("Kills ",kills)
	$HUD/MoneyLabel.text = str("$",money)

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	var mob_spawn_location = get_node("MobPath/SpawnLocation")
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	#var velocity = Vector2(rand_range(100.0, 150.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)
	mob.set_player($Player)
	add_child(mob)
	$MobTimer.start(rand_range(0.5,2.0))
	
func add_kill():
	kills += 1

func add_loot():
	money += 1
	
func _on_WaveTimer_timeout():
	pass # Replace with function body.
