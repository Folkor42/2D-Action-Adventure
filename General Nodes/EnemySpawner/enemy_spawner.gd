class_name EnemySpawner extends Node2D

enum SpawnMode { TIMER, TRIGGER, MANUAL }

@export var enabled : bool = true
@export var spawn_mode : SpawnMode = SpawnMode.TIMER
@export var enemies : Array[PackedScene] = []
@export var spawn_points : Array[Marker2D] = []
@export var spawn_timer : float = 2.0
@export var spawn_limit : int = 5
@export var trigger_node : Area2D

@export var waves : Array = [
	{"count": 3, "interval": 1.0},
	{"count": 5, "interval": 0.7}
]

@onready var timer : Timer = $Timer

var current_wave : int = 0
var enemies_spawned : int = 0
var active_enemies : Array = []

func _ready() -> void:
	if !enabled:
		return

	match spawn_mode:
		SpawnMode.TIMER:
			_start_timer()
		SpawnMode.TRIGGER:
			if trigger_node:
				trigger_node.body_entered.connect(_on_triggered)
		SpawnMode.MANUAL:
			 # spawn_now() called from external
			pass

func _start_timer() -> void:
	timer.wait_time = spawn_timer
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_triggered(body: CharacterBody2D) -> void:
	# If you use Groups: if body.is_in_group("player"):
	if body is Player:
		_start_wave_spawning()

func _start_wave_spawning() -> void:
	if current_wave >= waves.size():
		return
	var wave = waves[current_wave]
	enemies_spawned = 0
	timer.wait_time = wave["interval"]
	if not timer.timeout.is_connected(_on_wave_spawn):
		timer.timeout.connect(_on_wave_spawn)
	timer.start()

func _on_wave_spawn() -> void:
	if enemies_spawned < waves[current_wave]["count"]:
		_spawn_enemy()
		enemies_spawned += 1
	else:
		timer.stop()
		timer.timeout.disconnect(_on_wave_spawn)
		current_wave += 1
		if current_wave < waves.size():
			await get_tree().create_timer(1.5).timeout
			_start_wave_spawning()

func _on_timer_timeout() -> void:
	if active_enemies.size() < spawn_limit:
		_spawn_enemy()

func _spawn_enemy() -> void:
	if enemies.is_empty():
		return

	var enemy_scene: PackedScene = enemies.pick_random()
	var enemy = enemy_scene.instantiate()

	# Pick spawn point or default to spawner position
	if spawn_points.size() > 0:
		var marker = spawn_points.pick_random()
		if marker:
			enemy.position = marker.position
			# Make the Marker2Ds a child of the EnemySpawner as Global Position fails.

	add_child(enemy)

	active_enemies.append(enemy)
	enemy.tree_exited.connect(func(): active_enemies.erase(enemy))

func spawn_now(count: int = 1) -> void:
	for i in count:
		_spawn_enemy()
