extends Area2D

func _on_WinArea_body_entered(body):
	if body.is_in_group("Players"):
		get_tree().change_scene("res://Database/Database.tscn")
		
