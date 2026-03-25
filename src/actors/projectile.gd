extends Area2D

@onready var player = get_node("/root/Game/Player")
@onready var sprite = $AnimatedSprite2D
@onready var projectile = $"."
@onready var earth_arrow_sound = $EarthArrow
@onready var fire_arrow_sound = $FireArrow
@onready var air_arrow_sound = $AirArrow

var sound_played = false
var travel_distance = 0
var count_hit = 0;

func _physics_process(delta: float):
	var animation_str = ""
	
	if(player.mask_stack.has(1)):
		animation_str += "fire"
		if !fire_arrow_sound.is_playing() and !sound_played:
			fire_arrow_sound.play()
			
	if(player.mask_stack.has(2)):
		animation_str += "air"
		if !air_arrow_sound.is_playing() and !sound_played:
			air_arrow_sound.play()
			
	if(player.mask_stack.has(0)):
		animation_str += "earth"
		if !earth_arrow_sound.is_playing() and !sound_played:
			earth_arrow_sound.play()
			
	animation_str += "_arrow"
	sprite.play(animation_str)
	sound_played = true;
	
	const SPEED = 1200
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travel_distance += SPEED * delta
	if travel_distance > RANGE:
		queue_free()
		sound_played = false

func _on_body_entered(body: Node2D) -> void:
	if !body.has_method("take_dmg"):
		return
	body.take_dmg()
	if player.mask_stack.has(0):
		body.get_knocked_back(1.5)
	if player.mask_stack.has(1):
		body.take_fire_dmg()
	if player.mask_stack.has(2):
		sprite.scale *= 0.7
		count_hit += 1
		if count_hit == 3:
			queue_free()
	else: queue_free()
