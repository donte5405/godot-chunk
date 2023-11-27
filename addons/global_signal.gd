extends Node
class_name GlobalSignal


const KEY_AWAITED_SIGNALS = "_gs_"


static func _get_subscribers(signal_name: String) -> Dictionary:
	if not Engine.has_meta(KEY_AWAITED_SIGNALS):
		Engine.set_meta(KEY_AWAITED_SIGNALS, {})

	var awaited_signals := Engine.get_meta(KEY_AWAITED_SIGNALS) as Dictionary
	if not awaited_signals.has(signal_name):
		awaited_signals[signal_name] = {}
	return awaited_signals[signal_name]


static func _prep_signal(signal_name: String, arg_count: int) -> void:
	if Engine.has_signal(signal_name):
		return

	var properties := []
	properties.resize(arg_count)
	for i in arg_count:
		properties[i] = { name = "_%s" % i, type = TYPE_MAX }
	Engine.add_user_signal(signal_name, properties)

	var awaiting_subscribers := _get_subscribers(signal_name)
	for args in awaiting_subscribers.values():
		if is_instance_valid(args[1]):
			Engine.callv("connect", args)
	awaiting_subscribers.erase(signal_name)


# Get an awaiter to `yield()` from. Just wait for the signal with the same name as `signal_name`. For example. if you want to "yield" from `signal_name`, the code will be `yield(GlobalSignal.get_awaiter("signal_name"), "signal_name")`.
static func await(signal_name: String, arg_size: int = 0) -> Engine:
	_prep_signal(signal_name, arg_size)
	return Engine


# Emit signal along with parameters.
static func emit(signal_name: String, args: Array = []) -> void:
	_prep_signal(signal_name, args.size())
	Engine.callv("emit_signal", [ signal_name ] + args)


# Subscribe the signal name to function name of specified object.
static func subscribe(signal_name: String, object: Object, function_name: String, params: Array = [], flags: int = 0) -> void:
	if Engine.has_signal(signal_name):
		Engine.connect(signal_name, object, function_name, params)
		return

	var id := object.get_instance_id()
	var awaiting_subscribers := _get_subscribers(signal_name)
	if not awaiting_subscribers.has(id):
		awaiting_subscribers[id] = [ signal_name, object, function_name, params, flags ]


export var listen_to := NodePath(".")
export var listen_what := "signal_name"
export var emit_what := "global_signal_name"
export var emit_params := []


func _enter_tree() -> void:
	var target_node := get_node_or_null(listen_to)
	if not target_node:
		printerr(name + " cannot find target node " + String(listen_to))
		return
	while true:
		var result = yield(target_node, listen_what)
		if result == null:
			result = []
		elif not (result is Array):
			result = [ result ]
		emit(emit_what, result + emit_params)
