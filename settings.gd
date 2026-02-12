extends Control

@onready var sfx := get_node_or_null("Control/SFX")
@onready var bgm_toggle := get_node_or_null("Control/BgmToggle")
@onready var sfx_toggle := get_node_or_null("Control/SfxToggle")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


# 🔥 PANGGIL INI SETIAP UI MAU DIBUKA
func open():
	show()
	_sync_toggles()
	get_tree().paused = true


func close():
	hide()
	get_tree().paused = false


func _sync_toggles():
	if bgm_toggle:
		bgm_toggle.button_pressed = BGM.enabled

	if sfx_toggle:
		sfx_toggle.button_pressed = sfx != null


func _on_menu_pressed():
	if sfx:
		sfx.play()
	close()
	Fade.fade_to_scene("res://MainMenu.tscn")


func _on_retry_pressed():
	if sfx:
		sfx.play()
	close()
	Fade.fade_to_scene("res://Dunia.tscn")


func _on_bgm_toggled(toggled_on: bool):
	BGM.set_enabled(toggled_on)


func _on_sfx_toggled(toggled_on: bool):
	if sfx:
		sfx.volume_db = 0 if toggled_on else -80
