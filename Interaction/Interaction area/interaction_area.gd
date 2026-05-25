extends Area2D
class_name InteractionArea
#made with help from https://www.youtube.com/watch?v=ajCraxGAeYU

@export var action_name: String = "interact"

var _enabled: bool = true

var interact: Callable = func():
	pass

func _on_body_entered(body: Node2D) -> void:
	if _enabled:
		InteractionManager.register_area(self)

func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)

func set_enabled(enabled: bool) -> void:
	_enabled = enabled
	if not _enabled:
		InteractionManager.unregister_area(self)

func is_enabled() -> bool:
	return _enabled
