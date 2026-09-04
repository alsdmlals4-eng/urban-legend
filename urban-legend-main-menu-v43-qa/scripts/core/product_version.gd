class_name ProductVersion
extends RefCounted

const CURRENT := "4.3"


static func display_text() -> String:
	return "Ver %s" % CURRENT
