extends Node2D

var player: CharacterBody2D
var player_base_damage: int = 10

var enemy_sprite: Sprite2D
var enemy_health: int
var enemy_damage: int = 10

var sub_combat_enemy_array: Array[Array]
var health: int
var multiplier: float = .25

var in_combat_minigame: bool = false
var sub_combat_enemy_array_index: int = 0

# The sub combat enemy array, is an array that is iterated through every turn and the current index is the array of enemies that are spawned by default.
func init(enemy_sprite: Sprite2D, enemy_health: int, sub_combat_enemy_array: Array[Array], health: int):
	# Set combat parameters when scene is changed to combat.
	self.enemy_sprite = enemy_sprite
	self.enemy_health = enemy_health
	self.sub_combat_enemy_array = sub_combat_enemy_array
	self.health = health
	# Create player square.
	self.player = load("res://scenes/mini-player.tscn").instantiate()
	self.player.position.x = 160
	self.player.position.y = 140
	$MiniGameContent.add_child(self.player)
	# Put enemy sprite at the top of the screen
	self.enemy_sprite.position.x = 160
	self.enemy_sprite.position.y = 50
	self.enemy_sprite.name = "EnemySprite"
	add_child(self.enemy_sprite)
	
	$CombatTurnContent/FightButton.grab_focus()
	self.player.connect("death", end_combat)
	
	
func setup_combat_minigame():
	self.player.position.x = 160
	self.player.position.y = 140
	for enemy in self.sub_combat_enemy_array[sub_combat_enemy_array_index]:
		for enemy_position in enemy.positions_to_spawn:
			var enemy_instance = enemy.packed_scene.instantiate()
			enemy_instance.position = enemy_position
			$MiniGameContent.add_child(enemy_instance)

func set_in_combat_minigame(in_combat_minigame: bool):
	self.in_combat_minigame = in_combat_minigame
	$MiniGameContent.visible = in_combat_minigame
	$CombatTurnContent.visible = !in_combat_minigame
	if (in_combat_minigame):
		setup_combat_minigame()
	else:
		clear_combat_minigame()

func clear_combat_minigame():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

func end_combat():
	set_in_combat_minigame(false)
	damage_enemy(player_base_damage * multiplier)
	multiplier = .25
	$CombatTurnContent/FightButton.grab_focus()
	await get_tree().create_timer(1).timeout
	damage_player(enemy_damage)

func damage_enemy(damage: int):
	enemy_health -= damage
	get_tree().get_first_node_in_group("enemy_health").value = enemy_health
	await get_tree().create_timer(1).timeout
	if (enemy_health <= 0):
		win()
	
	
func damage_player(damage: int):
	health -= damage
	get_tree().get_first_node_in_group("player_health").value = health
	await get_tree().create_timer(1).timeout
	if (health <= 0):
		loss()

func win():
	print("won!")

func loss():
	print("L")

func _ready():
	var test_sprite = Sprite2D.new()
	test_sprite.texture = load("res://assets/sprite/test-enemy-sprite.png")
	var enemy_spawner_packed_scene: PackedScene = load("res://scenes/enemies/enemy-spawner-1.tscn")
	init(test_sprite, 100, [[{
		"packed_scene": enemy_spawner_packed_scene,
		"positions_to_spawn": [
			Vector2i(78,99),
			Vector2i(80,140),
			Vector2i(240,99),
			Vector2i(240,140)
		]
	}]], 100)

func _process(delta):
	if in_combat_minigame:
		multiplier += multiplier * (delta/6)
	get_tree().get_first_node_in_group("ui_multiplier").text = "%3.2f X" % multiplier


func _on_fight_button_pressed():
	set_in_combat_minigame(true)
