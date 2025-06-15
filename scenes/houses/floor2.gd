extends TileMapLayer

@onready var walls: TileMapLayer = $"../Walls"
@onready var furniture: TileMapLayer = $"../Furniture"
@onready var top_furniture: TileMapLayer = $"../TopFurniture"




func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	for maplayer:TileMapLayer in [walls, furniture, top_furniture]:
		if coords in maplayer.get_used_cells():
			return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	for maplayer:TileMapLayer in [walls, furniture, top_furniture]:
		if coords in maplayer.get_used_cells():
			tile_data.set_navigation_polygon(0, null)
		
	
