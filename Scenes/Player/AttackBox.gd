extends Area2D


func set_disabled(is_disabled: bool):
	$CollisionShape2D.set_deferred("disabled", is_disabled)
	
