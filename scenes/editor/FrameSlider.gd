extends HSlider

func _on_animation_loaded(num_of_frames):
	max_value = num_of_frames - 1

func _on_Timer_timeout():
	if value == max_value:
		value = 0
	else:
		value += 1
		
