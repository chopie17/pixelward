extends State

const ARAH_MAP = {
	"ui_right": {"vec": Vector2.RIGHT},
	"ui_left":  {"vec": Vector2.LEFT},
	"ui_up":    {"vec": Vector2.UP},
	"ui_down":  {"vec": Vector2.DOWN}
}

var durasi_serang = 0.4
var timer_serang = 0.0

func enter():
	timer_serang = durasi_serang
	var animasi = player.get_animasi()
	
	# Update arah terakhir jika ada input
	var arah_sekarang = get_arah_sekarang()	
	if arah_sekarang != Vector2.ZERO:
		player.arah_terakhir = arah_sekarang
	
	# Mulai animasi serang
	setup_animasi_serang(player.arah_terakhir, animasi)

func get_arah_sekarang():
	for action in ARAH_MAP.keys():
		if Input.is_action_pressed(action):
			return ARAH_MAP[action]["vec"]
	return Vector2.ZERO

func setup_animasi_serang(arah, animasi):
	const KECEPATAN_SLIDE = 80
	
	if arah != Vector2.ZERO:
		player.velocity = arah.normalized() * KECEPATAN_SLIDE
	
	if arah == Vector2.RIGHT:
		animasi.play("serang_samping")
		animasi.scale.x = 1
	elif arah == Vector2.LEFT:
		animasi.play("serang_samping")
		animasi.scale.x = -1
	elif arah == Vector2.UP:
		animasi.play("serang_atas")
	elif arah == Vector2.DOWN:
		animasi.play("serang_bawah")

func physics_update(delta):
	# Kurangi timer
	timer_serang -= delta
	
	# Update arah selama menyerang
	var arah_baru = get_arah_sekarang()
	if arah_baru != Vector2.ZERO:
		player.arah_terakhir = arah_baru
		setup_animasi_serang(arah_baru, player.get_animasi())
	
	# Cek jika serangan selesai
	if timer_serang <= 0:
		var arah_setelah_serang = get_arah_sekarang()
		if arah_setelah_serang != Vector2.ZERO:
			player.change_state("jalan")
		else:
			player.change_state("idle")

func exit():
	timer_serang = 0.0
