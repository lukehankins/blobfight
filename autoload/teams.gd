extends Node

var team_colors = {
	"UNKNOWN": Color(255,255,255),
	"NEUTRAL": Color(100,100,100),
	"red": Color(255,0,0),
	"green": Color(0,255,0),
	"blue": Color(255,0,255),
	"orange": Color(0.96078431606293, 0.42745098471642, 0.13333334028721),
	"purple": Color(0.56027537584305, 0.09232837706804, 0.77364259958267),
	"yellow": Color("YELLOW")
}

func get_team_color(team:String) -> Color:
	if team_colors[team]:
		return team_colors[team]
	else:
		return team_colors["UNKNOWN"]
