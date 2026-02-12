extends CharacterBody2D

const KECEPATAN = 80

var is_dead := false
var state: State
var states = {}
var arah_terakhir = Vector2.DOWN

@onready var sword_sfx: AudioStreamPlayer = $SwordSFX
@onready var death_sfx: AudioStreamPlayer = $DeathSFX


# === HP SYSTEM ===
@export var max_hp := 5
var hp := max_hp

@onready var hud := get_tree().get_first_node_in_group("hud")
@onready var result_ui := get_tree().get_first_node_in_group("result_ui")

func _ready():
	states["idle"] = load("res://states/IdleState.gd").new()
	states["jalan"] = load("res://states/JalanState.gd").new()
	states["serang"] = load("res://states/SerangState.gd").new()

	for s in states.values():
		s.player = self

	change_state("idle")
	update_hp_ui()

func get_animasi():
	return $AnimatedSprite2D

func change_state(new_state):
	if state:
		state.exit()
	state = states[new_state]
	state.enter()

func _physics_process(delta):
	if state:
		state.physics_update(delta)
		move_and_slide()

func _on_animated_sprite_2d_frame_changed():
	var anim := $AnimatedSprite2D
	var attack_box := $AttackBox

	if anim.animation.begins_with("serang") and anim.frame == 1:
		attack_box.monitoring = true
		attack_box.set_deferred("disabled", false)
		
		SFXPlayer.play(sword_sfx) # 🔊 SFX PEDANG
	else:
		attack_box.monitoring = false
		attack_box.set_deferred("disabled", true)

# === DAMAGE ===
func kena_damage(jumlah):
	hp -= jumlah
	hp = max(hp, 0)

	get_node("/root/Dunia/hud").update_hp(hp)

	if hp <= 0:
		mati()


func update_hp_ui():
	if hud == null:
		return

	for i in range(max_hp):
		var heart = hud.get_child(i)
		heart.visible = i < hp

func mati():
	if is_dead:
		return  # ⛔ STOP DI SINI

	is_dead = true
	print("PLAYER MATI")
	
	SFXPlayer.play(death_sfx)

	set_physics_process(false)
	set_process(false)
	get_animasi().play("mati")

	var game_over = get_tree().get_first_node_in_group("game_over_ui")
	if game_over:
		game_over.show_game_over()
	else:
		push_error("❌ GameOverUI TIDAK DITEMUKAN")
