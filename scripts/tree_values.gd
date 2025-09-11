extends Resource
class_name _TreeValues

var id: String
var title: String
var description: String

func _to_string() -> String:
	return "TreeValues(id=%s, title=%s, description=%s)" % [id, title, description]
