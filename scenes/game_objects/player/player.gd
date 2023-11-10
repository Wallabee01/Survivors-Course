extends CharacterBody2D

@onready var invulnerable_timer = $InvulnerableTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar as ProgressBar
@onready var abilities = $Abilities
@onready var anim_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var hit_sfx_component = $HitSFX2DComponent

var number_colliding_bodies = 0
var base_speed = 0


func _ready():
	base_speed = velocity_component.max_speed
	
	$DamageArea.body_entered.connect(on_body_entered)
	$DamageArea.body_exited.connect(on_body_exited)
	health_component.health_changed.connect(on_health_changed)
	invulnerable_timer.timeout.connect(on_invulnerable_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	update_health_display()


func _process(delta):
	#Movement
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	#Animation
	if movement_vector.x != 0 || movement_vector.y != 0:
		anim_player.play('walk')
	else:
		anim_player.play('RESET')
	
	#Flip player to match direction
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement).normalized()


func check_deal_damage():
	if number_colliding_bodies == 0 || !invulnerable_timer.is_stopped():
		return
	
	health_component.damage(1)
	invulnerable_timer.start()


func update_health_display():
		health_bar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_invulnerable_timer_timeout():
	invulnerable_timer.stop()
	check_deal_damage()


func on_health_changed():
	GameEvents.emit_player_damaged()
	hit_sfx_component.play_random()
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		abilities.add_child(ability_upgrade.ability_controller.instantiate())
	elif ability_upgrade.id == 'move_speed':
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades['move_speed']['quantity'] * 0.1)
