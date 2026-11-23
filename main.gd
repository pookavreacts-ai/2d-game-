extends Node2D

var player := Vector2(480, 270)
var speed := 260.0
var held := {}
var coins := []
var score := 0
var touch_move := Vector2.ZERO

func _ready():
    for i in range(18):
        coins.append(Vector2(randf_range(80,880), randf_range(80,460)))

func _process(delta):
    var v := Vector2.ZERO
    if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A): v.x -= 1
    if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D): v.x += 1
    if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W): v.y -= 1
    if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S): v.y += 1
    v += touch_move
    if v.length() > 1: v = v.normalized()
    player += v * speed * delta
    player.x = clamp(player.x, 24, 936)
    player.y = clamp(player.y, 24, 516)
    for i in range(coins.size()-1, -1, -1):
        if player.distance_to(coins[i]) < 28:
            coins.remove_at(i); score += 1
    queue_redraw()

func _draw():
    draw_rect(Rect2(0,0,960,540), Color("#73b86b"))
    # roads and sidewalks
    draw_rect(Rect2(0,190,960,160), Color("#4c5058"))
    draw_rect(Rect2(0,210,960,8), Color("#f4d35e"))
    draw_rect(Rect2(0,322,960,8), Color("#f4d35e"))
    draw_rect(Rect2(160,0,150,540), Color("#4c5058"))
    draw_rect(Rect2(181,0,8,540), Color("#f4d35e"))
    draw_rect(Rect2(281,0,8,540), Color("#f4d35e"))
    # buildings
    for r in [Rect2(35,35,95,115),Rect2(350,45,130,110),Rect2(530,35,140,120),Rect2(740,40,170,110),Rect2(350,390,130,105),Rect2(540,390,140,110),Rect2(745,390,160,100)]:
        draw_rect(r, Color("#b7a08a")); draw_rect(r, Color("#776451"), false, 4)
        for x in range(int(r.position.x+15),int(r.position.x+r.size.x-12),35):
            draw_rect(Rect2(x,r.position.y+18,18,22), Color("#b6e0ed"))
    for c in coins: draw_circle(c, 11, Color("#ffd447"))
    draw_circle(player, 17, Color("#2878d0"))
    draw_circle(player+Vector2(0,-4), 6, Color("#ffe0bd"))
    draw_string(ThemeDB.fallback_font, Vector2(22,32), "COINS: "+str(score), HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(22,70), "Move: WASD / Arrow keys / touch buttons", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            touch_move = _touch_vector(event.position)
        else: touch_move = Vector2.ZERO
    elif event is InputEventScreenDrag:
        touch_move = _touch_vector(event.position)

func _touch_vector(p):
    # Screen's lower-left and lower-right zones act as direction pads.
    if p.x < 240 and p.y > 300:
        return Vector2(-1,0) if p.x < 120 else Vector2(0,1)
    if p.x > 720 and p.y > 300:
        return Vector2(1,0) if p.x > 840 else Vector2(0,-1)
    return Vector2.ZERO
