class_name InventoryWindow
extends PanelContainer

@export var item_slot:PackedScene
@onready var equipamento = %Equipamento
@onready var inventario = %Inventario

func open(equipment:Array[Item], inventory:Array[Item]):
	show()
	
	for item in equipment:
		var slot = item_slot.instantiate()
		equipamento.add_child(slot)
		slot.display(item)
	
	for item in inventory:
		var slot = item_slot.instantiate()
		inventario.add_child(slot)
		slot.display(item)


func close():
	hide()
	for child in equipamento.get_children():
		child.queue_free()
	for child in inventario.get_children():
		child.queue_free()


func swap():
	print("swap!!!")
	$VBoxContainer.move_child(equipamento, 3)
	$VBoxContainer.move_child(inventario, 1)
