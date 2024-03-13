extends Area2D

@export var speed = 70
@onready var attack_box = $AttackBox
@onready var attack_over_timer = $AttackOverTimer
@onready var animated_sprite_2d = $AnimatedSprite2D

const ARMOR = preload("res://Resources/Items/armor.tres")
var health = 100
var defense = 0
var inventory: Array[Item] = []
var equipped_items: Array[Item] = []
var attacking = false

signal hp_changed(HP)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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



func get_inventory():
	return self.inventory


func get_equipment():
	return self.equipped_items


func give_defense(value: int):
	defense += value


func set_health(value: int):
	if value > 100:
		value = 100
	if value <= 0:
		self.death()
		value = 0
		
	self.health = value
	hp_changed.emit(health)


func hurt():
	set_health(health - 40 + defense)
	$InvincibilityFrames.start()
	$AnimatedSprite2D.modulate.a = 0.7


func death():
	self.visible = false
	self.set_process(false)
	$AttackStartTimer.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	

func _on_attack_timer_timeout():
	attacking = true
	animated_sprite_2d.play("attack")
	
	attack_box.position.x += 10 * (-1 if $AnimatedSprite2D.flip_h else 1)
	attack_box.set_disabled(false)
	attack_over_timer.start()
	
	await attack_over_timer.timeout
	attack_box.set_disabled(true)
	attack_box.position = Vector2.ZERO
	attacking = false


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
		set_health(health + 20)
		body.queue_free()
		
	if body.is_in_group("equipment"):
		inventory.append(ARMOR)
		body.queue_free()


func _on_invincibility_frames_timeout():
	$AnimatedSprite2D.modulate.a = 1
