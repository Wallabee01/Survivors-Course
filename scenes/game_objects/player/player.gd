extends CharacterBody2D

const MAX_SPEED = 100
const ACCELERATION_SMOOTHING = 25

@onready var invulnerable_timer = $InvulnerableTimer as Timer
@onready var health_component = $HealthComponent as HealthComponent
@onready var health_bar = $HealthBar as ProgressBar

var number_colliding_bodies = 0

func _ready():
	$DamageArea.body_entered.connect(on_body_entered)
	$DamageArea.body_exited.connect(on_body_exited)
	health_component.health_changed.connect(on_health_changed)
	invulnerable_timer.timeout.connect(on_invulnerable_timer_timeout)
	
	update_health_display()

func _process(delta):
	#Movement
	var direction = get_movement_vector()
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


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
	update_health_display()
