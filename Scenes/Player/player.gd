extends Area2D

@export var speed = 70
@onready var attack_box = $AttackBox
@onready var attack_over_timer = $AttackOverTimer
@onready var animated_sprite_2d = $AnimatedSprite2D

const ARMOR = preload("res://Resources/Items/armor.tres")
var player_health = 4
var player_defense = 0
var player_knockback = 500
var inventory: Array[Item] = []
var equipped_items: Array[Item] = []
var attacking = false

signal hp_changed(HP)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_handling():
	if Input.is_action_just_pressed("attack"):
		_attack()

func _physics_process(delta):
	_input_handling()
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.flip_h = false
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
		direction.x -= 1
		
	if direction.length() > 0:
		direction = direction.normalized()
		self.position += direction * speed * delta
	
	if not attacking:
		if direction.length() > 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

func _attack():
	attacking = true
	animated_sprite_2d.play("attack")
	
	#if attack_box.position.x == 0:
	attack_box.position.x += 10 * (-1 if $AnimatedSprite2D.flip_h else 1)
	attack_box.set_disabled(false)
	attack_over_timer.start()
	
	await attack_over_timer.timeout
	attack_box.set_disabled(true)
	attack_box.position = Vector2.ZERO
	attacking = false

func get_inventory():
	return self.inventory


func get_equipment():
	return self.equipped_items


func give_defense(value: int):
	player_defense += value


func set_health(value: int):
	if value > 4:
		value = 4
	if value <= 0:
		self.death()
		value = 0
		
	self.player_health = value
	hp_changed.emit(player_health)


func hurt():
	set_health(player_health - 1)
	$InvincibilityFrames.start()
	$AnimatedSprite2D.modulate.a = 0.7


func death():
	self.visible = false
	self.set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)


func _on_attack_box_body_entered(body):
	if body.is_in_group("enemy"):
		body.death()


func _on_body_entered(body):
	print("contato com")
	print(body.name)
	if body.is_in_group("enemy"):
		if $InvincibilityFrames.is_stopped():
			hurt()
			
	if body.is_in_group("potion"):
		set_health(player_health + 1)
		body.queue_free()
		
	if body.is_in_group("equipment"):
		inventory.append(ARMOR)
		body.queue_free()


func _on_invincibility_frames_timeout():
	$AnimatedSprite2D.modulate.a = 1
