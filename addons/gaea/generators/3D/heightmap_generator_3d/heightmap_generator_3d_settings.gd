class_name HeightmapGenerator3DSettings
extends GeneratorSettings3D

## Info for the tile that will be placed. Has information about
## it's position in the TileSet.
@export var tile: TileInfo
@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var random_noise_seed := true
## Infinite worlds only work with a [ChunkLoader3D].
@export var infinite := false
## The size in the x and z axis.
@export var world_size := Vector2(16, 16)
## The medium height at which the heightmap will start displacing from y=0.
## The heightmap displaces this height by a random number
## between -[param height_intensity] and [param height_intensity].
@export var height_offset := 128
## The heightmap displaces [param height_offset] by a random number
## from -[param height_intensity] to [param height_intensity].
@export var height_intensity := 20
## Negative values means the HeightmapGenerator will go below y=0.
@export var min_height := 0
