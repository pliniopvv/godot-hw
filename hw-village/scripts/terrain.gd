@tool
extends Node3D

@export_category("Configmap")
@export var size = 50
var map = {}

@onready var grama = preload("res://blocks/floor.tscn")
@onready var water = preload("res://blocks/water.tscn")

func _ready():
	generate_terrain()
	
func generate_terrain():
	randomize()
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.01
	var bloco
	
	var count_grama = 0
	var count_agua = 0
	
	for x in size:
		for y in size:
			if ((x < size*0.2 or x > size*0.8) or 
			(y < size*0.2 or y > size*0.8)):
				bloco = water.instantiate()
			if bloco == null:
				var tipo_bloco = noise.get_noise_2d(x,y)
				if tipo_bloco > 0.2:
					bloco = water.instantiate()
					count_grama += 1
				elif tipo_bloco <= 0.2:
					bloco = grama.instantiate()
					count_agua += 1
			insert_block(bloco, x, y)
			bloco = null
	print(count_grama,",", count_agua)

func get_key(x,y):
	return str(x) + "," + str(y)

func insert_block(bloco, x, y):
	var key = get_key(x,y)
	var block = bloco
	block.position.x = x
	block.position.z = y
	map[key] = block
	get_node(".").add_child(block)

func _process(delta):
	pass
