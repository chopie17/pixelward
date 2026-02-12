extends Control

@onready var sfx: AudioStreamPlayer = $SFX
@onready var settings: Control = $SettingsPopup
@onready var bgm_toggle: CheckButton = $SettingsPopup/Control/bgm
@onready var sfx_toggle: CheckButton = $SettingsPopup/Control/sfx

@onready var play_btn: TextureButton = $play
@onready var settings_btn: TextureButton = $settings
@onready var quit_btn: TextureButton = $quit

# ===== JOYSTICK MENU SYSTEM =====
var menu_index := 0
@onready var menu_buttons := [
	play_btn,
	settings_btn,
	quit_btn
]

# ===============================

func _ready():
	# UI
	get_tree().paused = false

	# ===== BGM (GLOBAL) =====
	BGM.player.volume_db = 0
	BGM.play(preload("res://music/menu.ogg"))
	bgm_toggle.button_pressed = BGM.enabled
		
	settings.hide()
	settings.process_mode = Node.PROCESS_MODE_ALWAYS
	$AnimatedSprite2D.play("idle")

	# ===== SFX =====
	sfx_toggle.button_pressed = true

	Fade.fade_in()

	# ===== AUTO FOCUS MENU =====
	await get_tree().process_frame
	menu_buttons[menu_index].grab_focus()


# ===== BGM =====
func fade_out_bgm(time := 0.5):
	if not BGM.player:
		return
	var tween = create_tween()
	tween.tween_property(BGM.player, "volume_db", -40, time)


func _on_bgm_toggled(is_on: bool):
	BGM.set_enabled(is_on)


# ===== SFX =====
func play_sfx():
	if sfx_toggle.button_pressed:
		sfx.play()


# ===== BUTTON MENU =====
func _on_play_pressed():
	play_sfx()
	fade_out_bgm(0.3)
	await get_tree().create_timer(0.3).timeout
	Fade.fade_to_scene("res://video.tscn")


func _on_quit_pressed():
	play_sfx()
	fade_out_bgm(0.5)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_settings_pressed():
	play_sfx()
	settings.show()


func _on_back_pressed():
	play_sfx()
	settings.hide()


# ===== INPUT HANDLING =====
func _input(event):
	# Mouse = lepas fokus
	if event is InputEventMouseMotion:
		get_viewport().gui_release_focus()


func _unhandled_input(event):
	# ===== NAVIGASI MENU (JOYSTICK / KEYBOARD) =====
	if event.is_action_pressed("ui_down"):
		menu_index += 1
		if menu_index >= menu_buttons.size():
			menu_index = 0
		_update_menu_focus()

	elif event.is_action_pressed("ui_up"):
		menu_index -= 1
		if menu_index < 0:
			menu_index = menu_buttons.size() - 1
		_update_menu_focus()

	# Kalau analog digerakin tapi fokus ilang
	if event is InputEventJoypadMotion and abs(event.axis_value) > 0.3:
		if get_viewport().gui_get_focus_owner() == null:
			menu_buttons[menu_index].grab_focus()


func _update_menu_focus():
	menu_buttons[menu_index].grab_focus()
	play_sfx()


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("🅰 UI ACCEPT KEPENCET")
		


func _on_leaderboard_pressed() -> void:
	play_sfx()
	$LeaderboardPopup.open()
