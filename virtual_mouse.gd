extends Node

@export var speed := 1200.0
var mouse_pos: Vector2

func _ready():
	mouse_pos = get_viewport().get_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if GameManager.input_mode != GameManager.InputMode.UI:
		return

	var dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if dir.length() > 0.1:
		mouse_pos += dir.normalized() * speed * delta
		mouse_pos = mouse_pos.clamp(Vector2.ZERO, get_viewport().size)
		Input.warp_mouse(mouse_pos)

func _unhandled_input(event):
	if GameManager.input_mode != GameManager.InputMode.UI:
		return

	if event.is_action_pressed("ui_accept"):
		_click(true)
	elif event.is_action_released("ui_accept"):
		_click(false)

func _click(pressed: bool):
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_LEFT
	ev.pressed = pressed
	ev.position = mouse_pos
	Input.parse_input_event(ev)
