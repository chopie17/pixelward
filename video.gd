extends Node2D

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("awal")

	# BGM GLOBAL
	BGM.player.volume_db = 0
	BGM.play(preload("res://music/Cutscene.ogg"))


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "awal":
		BGM.stop()
		get_tree().change_scene_to_file("res://text.tscn")
