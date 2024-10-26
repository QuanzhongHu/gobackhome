extends CharacterBody2D

# 玩家属性
var speed: float = 200.0  # 移动速度
var max_health: int = 100  # 最大生命值
var health: int = max_health  # 当前生命值
var can_attack: bool = true  # 攻击冷却
var attack_cooldown: float = 0.5  # 攻击冷却时间（秒）
var attack_timer: float = 0.0  # 攻击计时器

# 导出子弹场景
@export var bullet_scene: PackedScene  # 需要在编辑器中设置

# 引用准星节点
onready var crosshair = $Crosshair  # 我们稍后会添加Crosshair节点

func _ready() -> void:
	# 隐藏系统鼠标光标
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	# 将准星置于鼠标位置
	set_crosshair_position(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_attack(delta)
	update_crosshair_position()

func handle_movement(delta: float) -> void:
	var velocity = Vector2.ZERO

	# 使用 WASD 控制移动
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# 规范化速度向量并乘以速度
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed

	# 移动玩家
	velocity = move_and_slide(velocity)

func handle_attack(delta: float) -> void:
	# 更新攻击计时器
	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cooldown:
			can_attack = true
			attack_timer = 0.0

	# 检测攻击输入（鼠标左键或空格键）
	if can_attack and (Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("ui_select")):
		perform_attack()
		can_attack = false

func perform_attack() -> void:
	# 实例化子弹
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	# 计算子弹方向（指向鼠标位置）
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet.direction = direction
	get_tree().current_scene.add_child(bullet)

func update_crosshair_position() -> void:
	# 将准星移动到鼠标位置
	var mouse_position = get_global_mouse_position()
	crosshair.global_position = mouse_position

func set_crosshair_position(position: Vector2) -> void:
	crosshair.global_position = position

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	# 处理玩家死亡逻辑，例如显示游戏结束界面
	print("Player has died")
	get_tree().change_scene("res://GameOver.tscn")  # 需要创建GameOver场景
