extends CanvasLayer

var rect: ColorRect
var tween: Tween
var next_scene := ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10

	rect = ColorRect.new()
	rect.color = Color.BLACK
	rect.anchor_left = 0
	rect.anchor_top = 0
	rect.anchor_right = 1
	rect.anchor_bottom = 1
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(rect)

	# mulai dari hitam
	rect.modulate.a = 1.0

func fade_in(duration := 0.6):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, duration)

func fade_out(duration := 0.6):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)

func fade_to_scene(scene_path: String, duration := 0.6):
	next_scene = scene_path

	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)
	tween.tween_callback(_change_scene)

func _change_scene():
	get_tree().change_scene_to_file(next_scene)
	fade_in()
