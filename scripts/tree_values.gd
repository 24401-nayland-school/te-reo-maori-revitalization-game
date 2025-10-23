extends Resource
class_name _TreeValues

# Variables
var id: String
var title: String
var title_en: String
var description: String
var description_en: String

# Get _TreeValues as string
func _to_string() -> String:
	return "TreeValues(id=%s, title=%s)" % [id, title]
