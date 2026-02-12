extends Control

@onready var sfx = $SFX
@onready var bgm_gameover = preload("res://music/die.mp3")

func _ready():
	hide()
	sfx.process_mode = Node.PROCESS_MODE_ALWAYS

func show_game_over():
	# 🔥 ganti BGM jadi gameover
	BGM.play(bgm_gameover)
	BGM.player.stream.loop = false

	# ❌ JANGAN SAVE SCORE PAS KALAH
	# GameManager.save_score()

	show()
	get_tree().paused = true

func _on_retry_pressed():
	sfx.play()
	get_tree().paused = false
	Fade.fade_to_scene("res://Dunia.tscn")

func _on_menu_pressed():
	sfx.play()
	get_tree().paused = false
	BGM.stop()
	Fade.fade_to_scene("res://MainMenu.tscn")
