@tool
@icon("walls.svg")
class_name Walls
extends Modifier2D
## Adds [param wall_tile] below any tile that isn't the Generator's default tile.
## Useful for tilesets whose walls are different tiles from the ceiling.
## @tutorial(Walls Modifier): https://benjatk.github.io/Gaea/#/modifiers?id=-walls


## The tile to be placed. Will be placed below any tile
## that isn't the Generator's default tile.
@export var wall_tile: TileInfo


func apply(grid: Dictionary, generator: GaeaGenerator) -> Dictionary:
	# Check if the generator has a "settings" variable and if those
	# settings have a "tile" variable.
	if not generator.get("settings") or not generator.settings.get("tile"):
		push_warning("Walls modifier not compatible with %s" % generator.name)
		return grid

	var newGrid := grid.duplicate()
	for tile_pos in grid:
		if not _passes_filter(grid[tile_pos]):
				continue

		if grid[tile_pos] == generator.settings.tile:
			var above = tile_pos + Vector2.UP
			if grid.has(above) and grid[above] != generator.settings.tile:
				newGrid[tile_pos] = wall_tile

	return newGrid
