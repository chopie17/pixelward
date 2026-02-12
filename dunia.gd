extends Node2D

@export var boss_scene: PackedScene
@export var boss_spawn_pos: Vector2

func _ready():
	print("boss_scene:", boss_scene)
	
	BGM.player.volume_db = 0
	BGM.play(preload("res://music/dunia.mp3"))
	# 🔥 INI WAJIB
	GameManager.boss_scene = boss_scene
	GameManager.boss_spawn_pos = boss_spawn_pos
	GameManager.start_game()
	get_tree().paused = false
	Fade.fade_in()
