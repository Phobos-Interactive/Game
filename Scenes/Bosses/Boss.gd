extends CharacterBody2D

@export var speed = 00
@export var droplist:Array[Item]
@onready var player = $"../Player"
@onready var boss_sprite = $boss_sprite

var boss_health = 10
var boss_defense = 0
var attacking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimatedSprite2D.play("idle")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var route = (player.position - self.position) as Vector2
	
	if route.x > 0:
		$boss_sprite.flip_h = false
	else:
		$boss_sprite.flip_h = true
	velocity = route.normalized() * delta * speed
	move_and_slide()
	
	if not attacking:
		if velocity.length() > 0:
			boss_sprite.play("move")
		else:
			boss_sprite.play("idle")
	
	
func death():
	print("morreu")
	$boss_sprite.play("death")
	self.set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$boss_sprite.play("death")
	print("morreu")
	await $boss_sprite.animation_finished
	$boss_sprite.modulate.a = 0.5
		
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
