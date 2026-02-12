extends Node

var enabled := true

func play(player: AudioStreamPlayer):
	if not enabled:
		return
	if player:
		player.play()

func set_enabled(value: bool):
	enabled = value
