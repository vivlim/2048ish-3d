class_name AttributionList

extends Object

# Keys for attribution dictionaries.
const ATTRIBUTION_NAME = "Name"
const ATTRIBUTION_VERSION = "Version"
const ATTRIBUTION_URL = "URL"
const ATTRIBUTION_LICENSE = "License"
const ATTRIBUTION_USAGES = "Usages"
const ATTRIBUTION_NOTES = "Notes"
const ATTRIBUTION_START_DATE = "StartDate"
const ATTRIBUTION_SORT_ORDER = "SortOrder" # optional, smaller numbers are higher, fall back to alphabetical by name

# Keys for license dictionaries.
const LICENSE_NAME = "Name"
const LICENSE_URL = "URL"
const LICENSE_TEXT = "LicenseText"

var attribution_list: Array[Dictionary] = []

# Recurring licenses
const LICENSES_CC0_10_UNIVERSAL = {
	LICENSE_NAME: "CC0 1.0 Universal",
	LICENSE_URL: "https://creativecommons.org/publicdomain/zero/1.0/"
}

func add(attribution: Dictionary):
	self.attribution_list.append(attribution)

func _init():
	add_engine_attribs()
	self.add({
		ATTRIBUTION_NAME: "Kenney Game Assets All-in-1",
		ATTRIBUTION_USAGES: [
			"2D Assets/UI Base Pack: For UI elements"
		]
		ATTRIBUTION_URL: "https://kenney.itch.io/kenney-game-assets",
		ATTRIBUTION_LICENSE: LICENSES_CC0_10_UNIVERSAL,
		ATTRIBUTION_START_DATE: "2024 July"
	})

func add_engine_attribs():
	self.add({
		ATTRIBUTION_NAME: "Godot Engine",
		ATTRIBUTION_VERSION: Engine.get_version_info()["string"],
		ATTRIBUTION_START_DATE: "2024 July",
		ATTRIBUTION_LICENSE: {
			LICENSE_NAME: "MIT",
			LICENSE_TEXT: Engine.get_license_text()
		},
		ATTRIBUTION_USAGES: ["The entire game is built in it"]
	})
	self.add({
		ATTRIBUTION_NAME: "Godot Engine third-party components",
		ATTRIBUTION_START_DATE: "2024 July",
		"CopyrightInfo": Engine.get_copyright_info(),
		"LicenseInfoFlatText": Engine.get_copyright_info(),
		ATTRIBUTION_USAGES: ["The entire game is built on Godot Engine which depends on these"]
	})
