extends State

const ARAH_MAP = {
	"ui_right": {"vec": Vector2.RIGHT, "anim": "jalan_kanan", "scale_x": 1},
	"ui_left":  {"vec": Vector2.LEFT,  "anim": "jalan_kanan",  "scale_x": -1},
	"ui_up":    {"vec": Vector2.UP,    "anim": "jalan_atas"},
	"ui_down":  {"vec": Vector2.DOWN,  "anim": "jalan_bawah"}
}

func enter():
	pass  # Biarkan kosong, nanti di physics_update

func physics_update(_delta):
	var animasi = player.get_animasi()
	var input_vector = Vector2.ZERO
	var jalan = false
	
	# PRIORITAS 1: Tombol serang
	if Input.is_action_just_pressed("tombol_serang"):
		player.change_state("serang")
		return
	
	# PROSES INPUT PERGERAKAN
	for action in ARAH_MAP.keys():
		if Input.is_action_pressed(action):
			var data = ARAH_MAP[action]
			input_vector += data["vec"]
			player.arah_terakhir = data["vec"] # simpan arah terakhir
			animasi.play(data["anim"])
			if data.has("scale_x"):
				animasi.scale.x = data["scale_x"]
			jalan = true
	
	if jalan:
		# Terapkan velocity
		player.velocity = input_vector.normalized() * player.KECEPATAN
	else:
		# Tidak ada input, kembali ke idle
		player.change_state("idle")
