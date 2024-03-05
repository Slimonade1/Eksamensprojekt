extends Area2D

func _on_EdgeDetection_body_entered(body):
	body.turnAround()
