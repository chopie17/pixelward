extends CharacterBody2D

@onready var sprite := $AnimatedSprite2D
@onready var hitbox := $Hitbox
@onready var attack_area := $AttackArea

var player: CharacterBody2D
var sudah_mati := false

const KECEPATAN = 35
const DAMAGE = 1
const ATTACK_COOLDOWN = 1.0
const SEPARATION_RADIUS = 18

var bisa_serang := true

func _ready():
	sprite.play("idle")
	hitbox.area_entered.connect(kena_serang)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if sudah_mati or player == null:
		return

	var target_pos = player.global_position + Vector2(0, 10)
	var arah = (target_pos - global_position).normalized()
	var separation = get_separation_force()

	velocity = arah * KECEPATAN + separation
	move_and_slide()

func _on_attack_area_body_entered(body):
	if sudah_mati or not bisa_serang:
		return

	if body.is_in_group("player"):
		bisa_serang = false
		body.kena_damage(DAMAGE)
		await get_tree().create_timer(ATTACK_COOLDOWN).timeout
		bisa_serang = true

func get_separation_force() -> Vector2:
	var force := Vector2.ZERO

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy == self:
			continue

		var dist = global_position.distance_to(enemy.global_position)
		if dist < SEPARATION_RADIUS:
			force += (global_position - enemy.global_position).normalized() * 6

	return force

func kena_serang(area):
	if sudah_mati:
		return

	if area.name == "AttackBox" and area.monitoring:
		mati()

func mati():
	sudah_mati = true
	hitbox.set_deferred("monitoring", false)
	set_physics_process(false)
	sprite.play("mati")

	GameManager.add_score(1)   # ✅ SCORE FIX
	GameManager.tambah_kill()  # ✅ BOSS COUNTER

	await get_tree().create_timer(0.4).timeout
	queue_free()
