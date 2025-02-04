@tool
class_name GaeaGenerator2D
extends GaeaGenerator


## Used to transform a world position into a map position,
## mainly used by the [ChunkLoader]. May also be used by
## a [GaeaRenderer]. Otherwise doesn't affect generation.
@export var tile_size: Vector2i = Vector2i(16, 16)


const NEIGHBORS := [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN,
					Vector2(1, 1), Vector2(1, -1), Vector2(-1, -1), Vector2(-1, 1)]


### Utils ###


func get_tile(pos: Vector2) -> TileInfo:
	return grid[pos]


static func are_all_neighbors_of_type(grid: Dictionary, pos: Vector2, type: TileInfo) -> bool:
	for neighbor in NEIGHBORS:
		if not grid.has(pos + neighbor):
			continue

		if grid[pos + neighbor] != type:
			return false

	return true


static func get_neighbor_count_of_type(grid: Dictionary, pos: Vector2, type: TileInfo) -> int:
	var count = 0

	for neighbor in NEIGHBORS:
		if not grid.has(pos + neighbor):
			if type == null:
				count += 1
			continue

		if grid[pos + neighbor] == type:
			count += 1

	return count


static func get_tiles_of_type(type: TileInfo, grid: Dictionary) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for tile in grid:
		if grid[tile] == type:
			tiles.append(tile)

	return tiles


static func get_area_from_grid(grid: Dictionary) -> Rect2i:
	var keys = grid.keys()
	if keys.is_empty():
		return Rect2i()
	var rect: Rect2i = Rect2i(keys.front(), Vector2.ZERO)
	for k in keys: rect = rect.expand(k)
	return rect
