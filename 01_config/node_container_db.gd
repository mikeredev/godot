class_name NodeContainerDB extends RefCounted


static var node_tree: Dictionary = {
	"MGMT": {
		"name": "Management",
	},
	"DATA": {
		"name": "Data"
	},
	"DISPLAY": {
		"name": "Display",
		"containers": [
			"Splash",
			"Menu",
			"Overworld",
			"Port",
			"Sublocation",
			"Player",
			"HUD",
			"Dialog",
			"Camera" ]
	},
}
