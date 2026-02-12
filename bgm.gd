extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var enabled := true
var current_stream: AudioStream = null

func _ready():
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	if not player:
		push_error("❌ AudioStreamPlayer TIDAK ADA DI BGM.tscn")

func play(stream: AudioStream):
	current_stream = stream

	if not enabled:
		return

	if player.stream != stream:
		player.stream = stream
		player.stream.loop = true

	if not player.playing:
		player.play()

func stop():
	player.stop()

func set_enabled(value: bool):
	enabled = value
	if enabled:
		if current_stream:
			play(current_stream)
	else:
		stop()
