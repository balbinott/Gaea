@tool
@icon("chunk_loader.svg")
class_name ChunkLoader3D
extends Node3D


## The generator that loads the chunks.
@export var generator: ChunkAwareGenerator3D
## [b]Optional[/b]. In this case it is used to prevent
## generating chunks before the [GaeaRenderer] is ready, which
## prevents empty areas.
@export var renderer: GaeaRenderer3D
## Chunks will be loaded arround this Node.
## If set to null chunks will be loaded around (0, 0, 0)
@export var actor: Node3D
## The distance around the actor which will be loaded.
## The actual loading area will be this value in all directions.
@export var loading_radius: Vector3i = Vector3i(2, 2, 2)
## Amount of miliseconds the loader waits before it checks if new chunks need to be loaded.
@export_range(0, 1, 1, "or_greater", "suffix:ms")
var update_rate: int = 0
## Executes the loading process on ready [br]
## [b]Warning:[/b] No chunks might load if set to false.
@export var load_on_ready: bool = true
## If set to true, the Chunk Loader unloads chunks left behind
@export var unload_chunks: bool = true

var _last_run: int = 0
var _last_position: Vector3i
var required_chunks: Array[Vector3i]


func _ready() -> void:
	generator.erase()

	if load_on_ready and not Engine.is_editor_hint():
		if is_instance_valid(renderer) and not renderer.is_node_ready():
			await renderer.ready

		_update_loading(_get_actors_position())


func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return

	if generator.settings.get("infinite") == false:
		push_warning("Generator's settings at %s has infinite disabled, can't generate chunks." % generator.get_path())
		return

	var current_time = Time.get_ticks_msec()
	if current_time - _last_run > update_rate:
		# todo make check loading
		_try_loading()
		_last_run = current_time


# checks if chunk loading is neccessary and executes if true
func _try_loading() -> void:
	var actor_position: Vector3i = actor.global_position

	if actor_position == _last_position and required_chunks.is_empty():
		return

	_last_position = actor_position
	_update_loading(_get_actors_position())


# loads needed chunks around the given position
func _update_loading(actor_position: Vector3i) -> void:
	if is_instance_valid(renderer) and not renderer.is_node_ready():
		await renderer.ready

	if generator == null:
		push_error("Chunk loading failed because generator property not set!")
		return

	required_chunks = _get_required_chunks(actor_position)

	# remove old chunks
	if unload_chunks:
		var loaded_chunks: Array[Vector3i] = generator.generated_chunks
		for i in range(loaded_chunks.size() - 1, -1, -1):
			var loaded: Vector3i = loaded_chunks[i]
			if not (loaded in required_chunks):
				generator.unload_chunk(loaded)


	# load new chunks
	for required in required_chunks:
		if not generator.has_chunk(required):
			generator.generate_chunk(required)


func _get_actors_position() -> Vector3i:
	# getting actors positions
	var actor_position := Vector3i.ZERO
	if actor != null: actor_position = actor.global_position.round()

	var tile_position: Vector3i = actor_position / generator.tile_size

	var chunk_position := Vector3i(
		roundi(tile_position.x / generator.chunk_size),
		roundi(tile_position.y / generator.chunk_size),
		roundi(tile_position.z / generator.chunk_size)
	)

	return chunk_position


func _get_required_chunks(actor_position: Vector3i) -> Array[Vector3i]:
	var chunks: Array[Vector3i] = []

	var x_range = range(
		actor_position.x - abs(loading_radius).x,
		actor_position.x + abs(loading_radius).x + 1
	)
	var y_range = range(
		actor_position.y - abs(loading_radius).y,
		actor_position.y + abs(loading_radius).y + 1
	)
	var z_range = range(
		actor_position.z - abs(loading_radius).z,
		actor_position.z + abs(loading_radius).z + 1
	)

	for x in x_range:
		for y in y_range:
			for z in z_range:
				chunks.append(Vector3i(x, y, z))
	return chunks


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray

	if not is_instance_valid(generator):
		warnings.append("Generator is required!")

	return warnings
