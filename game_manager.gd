extends Node

enum InputMode { GAME, UI }
var input_mode := InputMode.GAME

signal score_changed(score: int)
signal time_changed(time: int)
	
var time := 0.0
var score := 0
var game_started := false   # ⬅️ PENTING

var sudah_simpan := false
var player_name := ""

var boss_scene: PackedScene = null
var boss_spawn_pos: Vector2

var kill_count := 0
var boss_spawned := false


# ================= SCORE =================
func add_score(value: int):
	score += value
	score_changed.emit(score)


# ================= TIMER =================
func _process(delta):
	if not game_started:
		return

	time += delta
	time_changed.emit(int(time))


func start_game():
	time = 0
	score = 0
	kill_count = 0
	boss_spawned = false
	game_started = true
	sudah_simpan = false   # ⬅️ PENTING

	score_changed.emit(score)
	time_changed.emit(0)



func stop_game():
	game_started = false


# ================= KILL & BOSS =================
func tambah_kill():
	kill_count += 1
	print("Kill:", kill_count)

	if kill_count >= 15 and not boss_spawned:
		spawn_boss()


func spawn_boss():
	if boss_scene == null:
		push_error("❌ boss_scene MASIH NULL (BELUM DI SET DARI DUNIA)")
		return

	boss_spawned = true
	call_deferred("_spawn_boss_deferred")

func _spawn_boss_deferred():
	var boss = boss_scene.instantiate()
	boss.global_position = boss_spawn_pos

	get_tree().current_scene.add_child(boss)
	await get_tree().physics_frame

	if boss.test_move(Transform2D.IDENTITY, Vector2.ZERO):
		print("❌ Spawn kena object, batal")
		boss.queue_free()
		boss_spawned = false
		return

	print("🔥 BOSS MUNCUL 🔥")
	
func save_score():
	if sudah_simpan:
		return

	sudah_simpan = true

	var data: Array = []

	if FileAccess.file_exists("user://leaderboard.json"):
		var file = FileAccess.open("user://leaderboard.json", FileAccess.READ)
		var text = file.get_as_text()
		file.close()

		var parsed = JSON.parse_string(text)
		if typeof(parsed) == TYPE_ARRAY:
			data = parsed
		else:
			data = []

	data.append({
		"name": player_name,
		"score": score,
		"time": int(time)
	})

	var file = FileAccess.open("user://leaderboard.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
