extends Node2D

export var playerSpeed = 420; #px
export var initialBallSpeed = 100; #px
export var ballSpeedIncreaseAmount = 1.2; #px
export var maxBallSpeed = 450 #px
var screenSize
var ballDirection = Vector2(-1, 0.0)
var ballSpeed = initialBallSpeed
var leftScore = 0
var rightScore = 0
var ballPosition
var rightPlayerPosition
var leftPlayerPosition
var totalFramesLabelDisplays = 10000
var framesLabelDisplays = 0

var playerOne
var playerTwo
var ball
var ballCollide

var ballTouchedPlayer1 = false
var ballTouchedPlayer2 = false

func _ready():
	print("Game initiated.")
	screenSize = get_viewport_rect().size
	playerOne = get_node("player1");
	playerTwo = get_node("player2");
	ball = get_node("theBall");
	ballCollide = ball.get_node("Area2D")
	set_process(true)
	pass

#func _physics_process(delta):
#	_process(delta)

func _process(delta):
	_handle_ball_collision(delta)
	_calculate_win_and_reset()
	_control_left_player(delta)
	_control_right_player(delta)
	_set_all_variables()
	
	pass
	
	
func _handle_ball_collision(delta):
	#ball position
	ballPosition = ball.position
	
	ballPosition += ballDirection * ballSpeed * delta
	
	if ((ballPosition.y < 0 and ballDirection.y < 0) or (ballPosition.y > screenSize.y and ballDirection.y > 0)):
		ballDirection.y = -ballDirection.y
		
	var area = ballCollide.get_overlapping_bodies()
	if (area.size() != 0):
		for body in area:
			if (body.is_in_group("player1") and !ballTouchedPlayer1):
				ballTouchedPlayer1 = true
				ballTouchedPlayer2 = false
				_change_ball_direction()
			if (body.is_in_group("player2") and !ballTouchedPlayer2):
				ballTouchedPlayer1 = false
				ballTouchedPlayer2 = true
				_change_ball_direction()
	
	pass


func _calculate_win_and_reset():
	# reset ball if it leaves the screen
	if (ballPosition.x < 0):
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		rightScore += 1
		ballTouchedPlayer1 = false
		ballTouchedPlayer2 = false
	if (ballPosition.x > screenSize.x):
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		leftScore += 1
		ballTouchedPlayer1 = false
		ballTouchedPlayer2 = false
	pass


func _control_left_player(delta):
	#Control left player movement
	leftPlayerPosition = playerOne.position
	if (leftPlayerPosition.y > 0 and Input.is_action_pressed("left_up")):
		leftPlayerPosition.y += -playerSpeed * delta
		
	if (leftPlayerPosition.y < screenSize.y and Input.is_action_pressed("left_down")):
		leftPlayerPosition.y += playerSpeed * delta
	
	pass


func _control_right_player(delta):
	#Control right player movement
	rightPlayerPosition = playerTwo.position
	if (rightPlayerPosition.y > 0 and Input.is_action_pressed("ui_up")):
		rightPlayerPosition.y += -playerSpeed * delta
		
	if (rightPlayerPosition.y < screenSize.y and Input.is_action_pressed("ui_down")):
		rightPlayerPosition.y += playerSpeed * delta
	
	pass

	
func _set_all_variables():
	#set all new variables values
	ball.position = ballPosition
	playerOne.position = leftPlayerPosition
	playerTwo.position = rightPlayerPosition
	get_node("leftScore").set_text(str(leftScore))
	get_node("rightScore").set_text(str(rightScore))
	
	pass
	
func _change_ball_direction():
	ballDirection.x = -ballDirection.x
	ballDirection.y =  randf() * 2 -1
	ballDirection = ballDirection.normalized()
				
	if (ballSpeed < maxBallSpeed): 
		ballSpeed *= ballSpeedIncreaseAmount
	
	pass
