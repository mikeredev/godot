class_name Registry extends RefCounted

static var root: NodeRoot
static var containers: Dictionary = {}


static func add_root(node: NodeRoot) -> void:
	if not root:
		root = node
		Debug.log("root node registered: %s" % node, 3)
		return
	Debug.log("root node already registered: %s" % node, 1)


static func add_container(node: NodeContainer) -> void:
	if not containers.has(node):
		containers[node.name] = node
		Debug.log("node container registered: %s" % node, 3)


static func get_root() -> NodeRoot:
	if not root:
		Debug.log("root node not found in registry", 1)
		return
	return root


static func get_container(node_name: String) -> NodeContainer:
	if not containers.has(node_name):
		Debug.log("node container not registered: %s" % node_name, 1)
		return null
	return containers[node_name]
