class_name NodeContainerDB extends RefCounted


static var node_tree: Dictionary = {
	"MGMT": {
		"name": "Management",
	},
	"DISPLAY": {
		"name": "Display",
		"containers": [ "Splash", "Menu", "Overland", "Port", "Sublocation", "Player", "Dialogue", "Camera" ]
	},
	"DATA": {
		"name": "Data"
	}
}
