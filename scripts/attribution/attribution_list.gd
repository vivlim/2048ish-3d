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
			"2D Assets/UI Base Pack: Decorative arrow buttons for touchscreen controls",
			"2D Assets/Game Icons: Wrench icon"
		],
		ATTRIBUTION_URL: "https://kenney.itch.io/kenney-game-assets",
		ATTRIBUTION_LICENSE: LICENSES_CC0_10_UNIVERSAL,
		ATTRIBUTION_START_DATE: "2024 July"
	})
	self.add({
		ATTRIBUTION_NAME: "Comic Relief",
		ATTRIBUTION_VERSION: "v1.102",
		ATTRIBUTION_USAGES: ["UI font"],
		ATTRIBUTION_URL: "https://github.com/loudifier/Comic-Relief",
		ATTRIBUTION_LICENSE: {
			LICENSE_NAME: "SIL Open Font License, Version 1.1",
			LICENSE_URL: "https://openfontlicense.org/open-font-license-official-text/",
			LICENSE_TEXT: LICENSES_COMIC_RELIEF_TEXT
		},
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


# License text below here

const LICENSES_COMIC_RELIEF_TEXT = """
Copyright 2013 Jeff Davis (https://github.com/loudifier/Comic-Relief)

This Font Software is licensed under the SIL Open Font License, Version 1.1.
This license is copied below, and is also available with a FAQ at:
http://scripts.sil.org/OFL


-----------------------------------------------------------
SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007
-----------------------------------------------------------

PREAMBLE
The goals of the Open Font License (OFL) are to stimulate worldwide
development of collaborative font projects, to support the font creation
efforts of academic and linguistic communities, and to provide a free and
open framework in which fonts may be shared and improved in partnership
with others.

The OFL allows the licensed fonts to be used, studied, modified and
redistributed freely as long as they are not sold by themselves. The
fonts, including any derivative works, can be bundled, embedded, 
redistributed and/or sold with any software provided that any reserved
names are not used by derivative works. The fonts and derivatives,
however, cannot be released under any other type of license. The
requirement for fonts to remain under this license does not apply
to any document created using the fonts or their derivatives.

DEFINITIONS
"Font Software" refers to the set of files released by the Copyright
Holder(s) under this license and clearly marked as such. This may
include source files, build scripts and documentation.

"Reserved Font Name" refers to any names specified as such after the
copyright statement(s).

"Original Version" refers to the collection of Font Software components as
distributed by the Copyright Holder(s).

"Modified Version" refers to any derivative made by adding to, deleting,
or substituting -- in part or in whole -- any of the components of the
Original Version, by changing formats or by porting the Font Software to a
new environment.

"Author" refers to any designer, engineer, programmer, technical
writer or other person who contributed to the Font Software.

PERMISSION & CONDITIONS
Permission is hereby granted, free of charge, to any person obtaining
a copy of the Font Software, to use, study, copy, merge, embed, modify,
redistribute, and sell modified and unmodified copies of the Font
Software, subject to the following conditions:

1) Neither the Font Software nor any of its individual components,
in Original or Modified Versions, may be sold by itself.

2) Original or Modified Versions of the Font Software may be bundled,
redistributed and/or sold with any software, provided that each copy
contains the above copyright notice and this license. These can be
included either as stand-alone text files, human-readable headers or
in the appropriate machine-readable metadata fields within text or
binary files as long as those fields can be easily viewed by the user.

3) No Modified Version of the Font Software may use the Reserved Font
Name(s) unless explicit written permission is granted by the corresponding
Copyright Holder. This restriction only applies to the primary font name as
presented to the users.

4) The name(s) of the Copyright Holder(s) or the Author(s) of the Font
Software shall not be used to promote, endorse or advertise any
Modified Version, except to acknowledge the contribution(s) of the
Copyright Holder(s) and the Author(s) or with their explicit written
permission.

5) The Font Software, modified or unmodified, in part or in whole,
must be distributed entirely under this license, and must not be
distributed under any other license. The requirement for fonts to
remain under this license does not apply to any document created
using the Font Software.

TERMINATION
This license becomes null and void if any of the above conditions are
not met.

DISCLAIMER
THE FONT SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT
OF COPYRIGHT, PATENT, TRADEMARK, OR OTHER RIGHT. IN NO EVENT SHALL THE
COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
INCLUDING ANY GENERAL, SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL
DAMAGES, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF THE USE OR INABILITY TO USE THE FONT SOFTWARE OR FROM
OTHER DEALINGS IN THE FONT SOFTWARE.

"""