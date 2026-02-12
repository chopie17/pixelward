extends State

func enter():
	var animasi = player.get_animasi()
	player.velocity = Vector2.ZERO
	
	# update animasi berdasarkan arah terakhir
	if player.arah_terakhir == Vector2.RIGHT:
		animasi.play("idle_kanan")
		animasi.scale.x = 1
	elif player.arah_terakhir == Vector2.LEFT:
		animasi.play("idle_kanan")
		animasi.scale.x = -1
	elif player.arah_terakhir == Vector2.UP:
		animasi.play("idle_atas")
	else:
		animasi.play("idle_bawah")

func physics_update(_delta):
	# PRIORITAS 1: Tombol serang
	if Input.is_action_just_pressed("tombol_serang"):
		player.change_state("serang")
		return
	
	# PRIORITAS 2: Input pergerakan
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		player.change_state("jalan")
