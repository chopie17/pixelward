extends Control

@onready var fade_rect: ColorRect = $ColorRect
@onready var sfx = $SFX
@export var win_bgm: AudioStream  # drag win.ogg di inspector

func _ready():
	sfx.process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	fade_rect.modulate.a = 1.0

func show_win():
	show()

	# ✅ SAVE SCORE CUMA PAS MENANG
	GameManager.save_score()

	# 🛑 STOP BGM DUNIA
	BGM.stop()

	# 🎵 PLAY BGM WIN
	if win_bgm:
		BGM.play(win_bgm)

	get_tree().paused = true

	# 🌑 FADE OUT (TERANG → GELAP)
	var tween = create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_retry_pressed():
	sfx.play()
	get_tree().paused = false
	await get_tree().create_timer(0.15).timeout
	get_tree().reload_current_scene()

func _on_menu_pressed():
	sfx.play()
	get_tree().paused = false
	await get_tree().create_timer(0.15).timeout
	get_tree().change_scene_to_file("res://MainMenu.tscn")
