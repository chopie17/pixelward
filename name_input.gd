extends Control

@onready var sfx: AudioStreamPlayer = $SFX

@onready var name_input: LineEdit = $Panel/LineEdit
@onready var anim: AnimatedSprite2D = $Panel/AnimatedSprite2D

func _ready() -> void:
	sfx.process_mode = Node.PROCESS_MODE_ALWAYS
	anim.play("idle")

func _on_oke_pressed() -> void:
	sfx.play()
	if name_input.text.strip_edges() == "":
		return

	GameManager.player_name = name_input.text.strip_edges()
	await get_tree().create_timer(0.15).timeout
	Fade.fade_to_scene("res://Dunia.tscn")
