extends Control

@onready var sfx = $SFX

func _ready():
	get_tree().paused = false
	Fade.fade_in()


func _on_oke_pressed() -> void:
	sfx.play()
	await get_tree().create_timer(0.3).timeout
	Fade.fade_to_scene("res://NameInput.tscn")
