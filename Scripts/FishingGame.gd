extends Control

const Fish = preload("res://Scripts/Fish.gd")

# Assign Main's Fishes node in the Inspector.
@export var fishes: Node

var clicks: int = 0
var fish_caught: int = 0
var round_active: bool = false

var fish: Fish

@onready var fish_bounds: Control = $OuterPanel/MarginContainer/VBoxContainer/FishingArea/FishBounds
@onready var round_timer: Timer = $RoundTimer
@onready var time_label: Label = $OuterPanel/MarginContainer/VBoxContainer/Header/TimeLabel
@onready var clicks_label: Label = $OuterPanel/MarginContainer/VBoxContainer/Header/ClicksLabel
@onready var caught_label: Label = $OuterPanel/MarginContainer/VBoxContainer/Header/CaughtLabel
@onready var result_label: Label = $OuterPanel/MarginContainer/VBoxContainer/Footer/ResultLabel


func _ready():
	Global.fishing_opened.connect(open)
	Global.fish_clicked.connect(_on_fish_clicked)

	if visible:
		open()

func _process(_delta: float) -> void:
	if round_active:
		time_label.text = "Time: " + str(snapped(round_timer.time_left, 0.1))

func open() -> void:
	show()
	start_round()


func start_round():
	round_active = false
	round_timer.stop()
	if fish != null:
		fish.stop()
		fish_bounds.remove_child(fish)
		fish.queue_free()
		fish = null
	clicks = 0

	var available_fish: Array[Node] = []
	if fishes != null:
		for child in fishes.get_children():
			if child is Fish:
				available_fish.append(child)

	# Keep the editable original in Main and play with a copy.
	fish = available_fish.pick_random().duplicate() as Fish
	fish_bounds.add_child(fish)
	fish.position = Vector2.ZERO
	round_active = true

	clicks_label.text = "Clicks: 0 / " + str(fish.clicks_required)
	time_label.text = "Time: " + str(fish.time_limit)
	result_label.text = "Click " + fish.fish_name + "!"

	round_timer.start(fish.time_limit)
	fish.start()

func _on_fish_clicked():
	if not round_active:
		return
	clicks += 1
	clicks_label.text = "Clicks: " + str(clicks) + " / " + str(fish.clicks_required)
	if clicks >= fish.clicks_required:
		finish_round(true)


func finish_round(won: bool) -> void:
	round_active = false
	time_label.text = "Time: " + str(snapped(round_timer.time_left, 0.1))
	round_timer.stop()
	fish.stop()
	if won:
		fish_caught += 1
		result_label.text = "You caught a fish!"
		Global.fish_caught.emit(fish.fish_name, fish.texture_normal)
	else:
		result_label.text = "The fish got away!"
		time_label.text = "Time: 0.0 s"
	caught_label.text = "Caught: " + str(fish_caught)


func close() -> void:
	round_active = false
	round_timer.stop()
	if fish != null:
		fish.stop()
	hide()
	Global.fishing_closed.emit()


func _on_close_button_pressed() -> void:
	close()


func _on_round_timer_timeout() -> void:
	finish_round(false)
