extends Area2D

signal next_cp(body: PhysicsBody2D, n: int)
@export var n: int = 0

func _on_body_entered(player):
	emit_signal("next_cp", player, n)
