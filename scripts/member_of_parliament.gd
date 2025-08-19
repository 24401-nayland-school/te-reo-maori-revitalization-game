class_name MemberOfParliament
extends RefCounted

enum Party { LABOUR, NATIONAL, GREENS, ACT, MĀORI }

var name: String
var party: Party
var portrait_path: String

func _init(_name: String, _party: Party, _portrait_path: String) -> void:
	name = _name
	party = _party
	portrait_path = _portrait_path
