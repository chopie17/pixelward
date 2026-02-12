extends Control

@onready var list = $Panel/ScrollContainer/List
@export var row_scene: PackedScene
@onready var sfx: AudioStreamPlayer = $SFX

	
func _ready():
	load_leaderboard()
	get_tree().paused = false
	Fade.fade_in()
	hide()

func close():
	
	hide()


func load_leaderboard():
	for c in list.get_children():
		c.queue_free()

	var path := "user://leaderboard.json"
	if not FileAccess.file_exists(path):
		print("❌ leaderboard.json BELUM ADA")
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("❌ Gagal buka file")
		return

	var data: Array = JSON.parse_string(file.get_as_text())

	data.sort_custom(func(a, b):
		if a["score"] == b["score"]:
			return a["time"] < b["time"] # time lebih cepat = lebih atas
		return a["score"] > b["score"]   # score lebih besar = lebih atas
)


	var rank := 1
	for entry in data:
		add_row(rank, entry)
		rank += 1

func open():
	show()
	load_leaderboard() # biar refresh tiap buka

func add_row(rank: int, entry: Dictionary):
	var row = row_scene.instantiate()

	row.get_node("Rank").text = str(rank)
	row.get_node("Name").text = entry["name"]
	row.get_node("Score").text = str(entry["score"])
	row.get_node("Time").text = str(entry["time"]) + "s"

	list.add_child(row)


func _on_oke_pressed() -> void:
	sfx.play()
	close()
