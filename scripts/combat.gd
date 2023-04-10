extends Node2D

var enemy_sprite: Sprite2D
var enemy_health: int
var sub_combat_enemy_array: Array[Array]
var health: int

var sub_combat_enemy_array_index: int = 0

# The sub combat enemy array, is an array that is iterated through every turn and the current index is the array of enemies that are spawned by default.
func init(enemy_sprite: Sprite2D, enemy_health: int, sub_combat_enemy_array: Array[Array], health: int):
	self.enemy_sprite = enemy_sprite
	self.enemy_health = enemy_health
	self.sub_combat_enemy_array = sub_combat_enemy_array
	self.health = health
	
	self.enemy_sprite.position.x = 160
	self.enemy_sprite.position.y = 50
	self.enemy_sprite.name = "EnemySprite"
	$MiniGameContent.add_child(self.enemy_sprite)
	
	for enemy in sub_combat_enemy_array[sub_combat_enemy_array_index]:
		$MiniGameContent.add_child(enemy)
		
	
func _ready():
	var test_sprite = Sprite2D.new()
	test_sprite.texture = load("res://assets/sprite/test-enemy-sprite.png")
	var enemy_spawner_1: CharacterBody2D = load("res://scenes/enemies/enemy-spawner-1.tscn").instantiate()
	enemy_spawner_1.position.x = 78
	enemy_spawner_1.position.y = 109
	init(test_sprite, 100, [[enemy_spawner_1]], 100)
	
func _process(delta):
	print(get_viewport().get_mouse_position())
