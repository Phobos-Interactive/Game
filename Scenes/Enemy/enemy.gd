extends CharacterBody2D

@export var speed = 2000
@export var droplist:Array[Item]
@onready var player = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_delta = (player.position - self.position) as Vector2
	
	if pos_delta.x > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
	velocity = pos_delta.normalized() * delta * speed
	move_and_slide()
	
	
func death():
	self.set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.modulate.a = 0.5
	
	if (randi() % 100) < 50:
		var new_drop = droplist.pick_random().scene.instantiate()
		new_drop.global_position = self.global_position
		get_parent().call_deferred("add_child", new_drop)
		
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
