@tool
class_name GaeaGenerator3D
extends GaeaGenerator


## Used to transform a world position into a map position,
## mainly used by the [ChunkLoader]. May also be used by
## a [GaeaRenderer]. Otherwise doesn't affect generation.[br]
## [b]In meters.
@export var tile_size: Vector3i = Vector3i(1, 1, 1)


const NEIGHBORS := [Vector3.RIGHT, Vector3.LEFT, Vector3.UP, Vector3.DOWN,
					Vector3.FORWARD, Vector3.BACK]


### Utils ###


func get_tile(pos: Vector3) -> TileInfo:
	return grid[pos]


static func get_tiles_of_type(type: TileInfo, grid: Dictionary) -> Array[Vector3]:
	var tiles: Array[Vector3] = []
	for tile in grid:
		if grid[tile] == type:
			tiles.append(tile)

	return tiles


static func get_area_from_grid(grid: Dictionary) -> AABB:
	var keys = grid.keys()
	if keys.is_empty():
		return AABB()
	var aabb: AABB = AABB(keys.front(), Vector3.ZERO)
	for k in keys:
		aabb = aabb.expand(k)
	return aabb


static func has_empty_neighbor(grid: Dictionary, pos: Vector3) -> bool:
	for neighbor in NEIGHBORS:
		if not grid.has(pos + neighbor):
			return true

	return false
