extends Area2D

var speed: float = 500.0  # 子弹速度
var direction: Vector2 = Vector2.ZERO  # 子弹的移动方向

func _physics_process(delta: float) -> void:
	# 更新子弹的位置
	position += direction * speed * delta

	# 检查子弹是否超出屏幕范围，超出则销毁
	if not get_viewport_rect().encloses(global_position):
		queue_free()

func _on_Bullet_body_entered(body: Node) -> void:
	# 检测子弹与敌人的碰撞
	if body.is_in_group("Enemies"):
		if body.has_method("take_damage"):
			body.take_damage(10)  # 对敌人造成伤害，数值可调整
		queue_free()  # 销毁子弹
