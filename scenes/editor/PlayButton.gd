extends Button

func _on_Button_toggled(button_pressed):
	if button_pressed:
		$Timer.start()
	else:
		$Timer.stop()
