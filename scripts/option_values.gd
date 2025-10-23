extends Resource
class_name OptionValues

# Variables
var id: String
var title: String
var title_en: String

# Impact variables
var public_support: int = 0
var language_strength: int = 0
var political_capital: int = 0
var budget: int = 0

# Check if this option has any impacts
func has_impacts() -> bool:
	return public_support != 0 or language_strength != 0 or political_capital != 0 or budget != 0

# Get OptionValues as string
func _to_string() -> String:
	var impact_str = ""
	if has_impacts():
		impact_str = " [PS:%d LS:%d PC:%d B:%d]" % [public_support, language_strength, political_capital, budget]
	return "OptionValues(id=%s, title=%s%s)" % [id, title, impact_str]
