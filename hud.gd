extends CanvasLayer

@onready var hp_bar: AnimatedSprite2D = get_node_or_null("HPBar")
@onready var settings: Control = $SettingsPopup
@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel

var settings_open := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.score_changed.connect(set_score)
	GameManager.time_changed.connect(set_time)

	if hp_bar:
		update_hp(5)

	if settings:
		settings.hide()
		settings.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("ui_pause"):
		if settings_open:
			close_settings()
		else:
			open_settings()


func set_score(value: int):
	$ScoreLabel.text = "Score: %d" % value

func set_time(value: int):
	time_label.text = "Time: %d" % value

func open_settings():
	settings_open = true
	settings.open()   # 🔥 PAKAI API SETTINGS


func close_settings():
	settings_open = false
	settings.close()  # 🔥 PAKAI API SETTINGS

func update_hp(hp):
	if not hp_bar:
		return
	hp = clamp(hp, 0, 5)
	hp_bar.play("hp_%d" % hp)
