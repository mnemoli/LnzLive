extends OptionButton

export var lnz = ["test.lnz", "Dachsund.lnz", "dali.lnz", "sheepdog.lnz", "jack.lnz"]

signal file_selected(file_name)
signal file_saved(file_name)

func _on_OptionButton_item_selected(index):
	emit_signal("file_selected", lnz[index])

func _on_Button_pressed():
	emit_signal("file_selected", lnz[self.selected])

func _on_TextEdit_file_saved():
	emit_signal("file_saved", lnz[self.selected])
