extends Control


@export var fish_collection_icon: PackedScene
@onready var grid = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.fish_caught.connect(add_icon)
	pass # Replace with function body.



func add_icon(fish_name, texture):
	var icon = fish_collection_icon.instantiate()
	grid.add_child(icon)
	icon.setup(fish_name, texture)


func _on_collection_button_pressed():
	$PanelContainer.show()
	pass # Replace with function body.


func _on_close_button_pressed():
	$PanelContainer.hide()
	pass # Replace with function body.
