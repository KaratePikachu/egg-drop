extends CharacterBody2D
class_name Egg

@onready var SFXUmbrellaOpen = $SFXUmbrellaOpen
@onready var SFXUmbrellaOpen2 = $SFXUmbrellaOpen2
@onready var SFXUmbrellaWhoosh = $SFXUmbrellaWhoosh
@onready var SFXFanL = $SFXFanL
@onready var SFXFanR = $SFXFanR
@onready var SFXBomb = $SFXBomb
@onready var SFXEggCrack = $SFXEggCrack

@export var parachute_terminal_velocity: float

@export var stiffness: float = 10.0
@export var damping: float = 5

@export var tilt_factor: float = -5000.0
@export var drag_x: float = 20.0
@export var bomb_impulse: float = 800
@export var fan_power: float = 10

@export var modifications: Array[Modification]

var omega: float = 0.0
var fan_force = 0
var parachute_open: bool
var theta: float = 0.0
var landed: bool = false

var is_dead : bool = false

signal die

func _refresh_mods() -> void:
	for mod : Modification in modifications:
		mod.used = false
		mod.toggled = false
		if mod.icon_off:
			var icon := Sprite2D.new()
			icon.texture = mod.icon_off
			icon.name = mod.name + "_sprite_off"
			add_child(icon)
		if has_node(mod.name + "_sprite"):
			get_node(mod.name + "_sprite").hide()

func _ready() -> void:
	_refresh_mods()

func _input(event: InputEvent) -> void:
	if landed:
		return
	for mod in modifications:
		if not event.is_action_pressed(mod.input):
			continue
		
		if mod.is_single_use and mod.used:
			continue
		
		if mod.is_single_use:
			activate_mod(mod)
			mod.used = true
		else:
			if not mod.toggled:
				activate_mod(mod)
			else:
				deactivate_mod(mod)
		return

func deactivate_mod(mod: Modification) -> void:
	if mod.toggled == false:
		return
	mod.toggled = false
	
	
	if has_node(mod.name + "_sprite"):
		get_node(mod.name + "_sprite").hide()
	if has_node(mod.name + "_sprite_off"):
		get_node(mod.name + "_sprite_off").show()
		
	match mod.name:
		"left_fan":
			SFXFanL.stop()
			fan_force -= -fan_power
		"right_fan":
			SFXFanR.stop()
			fan_force -= fan_power
		"basic_umbrella":
			parachute_open = false
			SFXUmbrellaOpen.play()
			SFXUmbrellaWhoosh.stop()
	
func activate_mod(mod: Modification) -> void:
	if mod.toggled == true:
		return
	mod.toggled = true
	
	# icon
	var icon := get_node_or_null(mod.name + "_sprite") as Sprite2D
	if icon:
		icon.show()
	else:
		icon = Sprite2D.new()
		icon.texture = mod.icon
		icon.name = mod.name + "_sprite"
		add_child(icon)
		
	# icon off
	if has_node(mod.name + "_sprite_off"):
		get_node(mod.name + "_sprite_off").hide()
	
	match mod.name:
		"left_fan":
			fan_force += -fan_power
			SFXFanL.play()
		"right_fan":
			fan_force += fan_power
			SFXFanR.play()
		"basic_umbrella":
			parachute_open = true
			theta = 0
			SFXUmbrellaOpen2.play()
			SFXUmbrellaWhoosh.play()
		"right_bomb":
			if parachute_open:
				omega = -8
				theta = -0.5
				velocity.x = 8000
			else:
				omega = -3
				velocity.x += bomb_impulse
			SFXBomb.play()
		"left_bomb":
			if parachute_open:
				omega = 8
				theta = 0.5
				velocity.x = -8000
			else:
				omega = 3
				velocity.x -= bomb_impulse
			SFXBomb.play()
		"bottom_bomb":
			if parachute_open:
				velocity.y = -1200
			else:
				velocity.y = -800
			SFXBomb.play()
				
func land(died: bool) -> void:
	for mod in modifications:
		deactivate_mod(mod)
	landed = true
	velocity.x = 0
	parachute_open = true
	if died:
		death()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var torque = fan_force
	var omega_accel = torque
	if parachute_open:
		omega_accel -= stiffness * theta + damping * omega
	
	if parachute_open:
		var accel = sin(theta) * tilt_factor * 1.5 - drag_x * velocity.x
		velocity.x += accel * delta
		if not landed:
			velocity.y += (parachute_terminal_velocity - velocity.y) * delta * 1.5
	else:
		if not landed:
			velocity.y += (800 * delta)
			
	omega += omega_accel * delta
	if parachute_open:
		theta += omega * delta
	else:
		theta += omega * delta * 0.2
	rotation = theta
	move_and_slide()

func death() -> void:
	for node in get_children():
		if node is Sprite2D:
			node.hide()
	is_dead = true
	SFXEggCrack.play()
	$CPUParticles2D.show()
	$CPUParticles2D.emitting = true
	await $CPUParticles2D.finished
	die.emit()
	queue_free()
