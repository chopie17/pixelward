extends Node2D

@export var slime_scene: PackedScene
@export var total_spawn := 10
@export var spawn_delay := 1.0

var spawned := 0
var spawning := true   # ⬅️ FLAG KUNCI

func _ready():
	call_deferred("spawn_slime")

func spawn_slime():
	if not spawning:
		return

	if spawned >= total_spawn:
		return

	var slime = slime_scene.instantiate()
	slime.global_position = get_spawn_position()
	get_parent().add_child(slime)

	spawned += 1

	await get_tree().create_timer(spawn_delay, true).timeout
	spawn_slime()

func stop_spawn():
	spawning = false

func resume_spawn():
	spawning = true
	spawn_slime()

func get_spawn_position():
	return Vector2(
		randf_range(50, 600),
		randf_range(50, 400)
	)
