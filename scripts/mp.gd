extends Node2D

@onready var sprite := $Sprite2D


func update(mp: MemberOfParliament) -> void:
	if mp.party == mp.Party.LABOUR:
		sprite.texture = false
