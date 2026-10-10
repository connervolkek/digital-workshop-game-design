extends PanelContainer


func setup(fish_name, texture):
	$MarginContainer/VBoxContainer/Label.text = fish_name
	$MarginContainer/VBoxContainer/TextureRect.texture = texture
