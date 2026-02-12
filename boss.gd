extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox
@onready var boss_bgm := preload("res://music/boss.mp3")


var player: CharacterBody2D
var mati := false

# 🔥 STAT BOSS
var hp := 7
const KECEPATAN := 24
const DAMAGE := 2
const ATTACK_COOLDOWN := 0.8
const JARAK_SERANG := 20.0   # ⬅ jarak serang boss

var bisa_serang := true

func _ready():
	BGM.play(boss_bgm)
	
	if sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")

	player = get_tree().get_first_node_in_group("player")

	if hitbox:
		hitbox.area_entered.connect(_kena_serang)

func _physics_process(_delta):
	if mati or player == null:
		return

	var arah = player.global_position - global_position
	var jarak = arah.length()

	# 👈👉 FLIP KIRI / KANAN
	sprite.flip_h = arah.x < 0

	# 🗡 SERANG JIKA DEKAT
	if jarak <= JARAK_SERANG:
		_serang_player()
		velocity = Vector2.ZERO
	else:
		velocity = arah.normalized() * KECEPATAN

	move_and_slide()

func _serang_player():
	if mati or not bisa_serang:
		return

	if player.is_in_group("player"):
		bisa_serang = false
		player.kena_damage(DAMAGE)
		print("💥 BOSS SERANG PLAYER")

		await get_tree().create_timer(ATTACK_COOLDOWN).timeout
		bisa_serang = true

func _kena_serang(area):
	print("BOSS KENA:", area.name, area.monitoring)
	if mati:
		return

	if area.is_in_group("attack") and area.monitoring:
		hp -= 1
		sprite.modulate = Color(1, 0.6, 0.6)
		await get_tree().create_timer(0.1).timeout
		sprite.modulate = Color.WHITE

		if hp <= 0:
			mati_boss()


func mati_boss():
	mati = true
	hitbox.set_deferred("monitoring", false)

	sprite.play("mati")
	print("🏆 BOSS KALAH")

	var win_ui = get_tree().get_first_node_in_group("win_ui")
	if win_ui:
		win_ui.show_win()

	await get_tree().create_timer(0.6).timeout
	queue_free()
