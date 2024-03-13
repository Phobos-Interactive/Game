extends Node2D

@onready var progress_bar = $CanvasLayer/GUI/ProgressBar
@onready var inventory_window = $CanvasLayer/InventoryWindow
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var player = $Player
var _inv_open = false

func _unhandled_input(event):
	if event.is_action_released("open_inventory"):
		if _inv_open:
			inventory_window.close()
		else:
			inventory_window.open(player.get_equipment(), player.get_inventory())
		_inv_open = not _inv_open
	if event.is_action_released("select"):
		if _inv_open:
			inventory_window.swap()
		player.give_defense(10)

func _on_player_hp_changed(HP):
	progress_bar.value = HP
	if HP == 0:
		game_over_screen.show()

