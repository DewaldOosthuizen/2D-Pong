extends Node2D

export var playerSpeed = 400; #px
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
var playerOneTexture
var playerTwoTexture
var ball
var leftColide
var rightColide

func _ready():
	print("Game initiated.")
	screenSize = get_viewport_rect().size
	playerOne = get_node("player1");
	playerTwo = get_node("player2");
	playerOneTexture = get_node("player1/leftPlayer");
	playerTwoTexture = get_node("player2/rightPlayer");
	ball = get_node("theBall");
	set_process(true)
	pass


func _process(delta):
	_handle_ball_collision(delta)
	_calculate_win_and_reset()
	_control_left_player(delta)
	_control_right_player(delta)
	_set_all_variables()
	
	pass
	
	
func _handle_ball_collision(delta):
	#Colliders
	var leftColide = Rect2(playerOne.position - playerOneTexture.texture.get_size()*0.7, playerOneTexture.texture.get_size())
	var rightColide = Rect2(playerTwo.position - playerTwoTexture.texture.get_size()*0.7, playerTwoTexture.texture.get_size())
	
	#ball position
	ballPosition = ball.position
	
	ballPosition += ballDirection * ballSpeed * delta
	
	if ((ballPosition.y < 0 and ballDirection.y < 0) or (ballPosition.y > screenSize.y and ballDirection.y > 0)):
		ballDirection.y = -ballDirection.y
		
	if (leftColide.has_point(ballPosition) or rightColide.has_point(ballPosition)):
		ballDirection.x = -ballDirection.x
		ballDirection.y =  randf() * 2 -1
		ballDirection = ballDirection.normalized()
		
		if (ballSpeed < maxBallSpeed): 
			ballSpeed *= ballSpeedIncreaseAmount
	
	pass


func _calculate_win_and_reset():
		# reset ball if it leaves the screen
	if (ballPosition.x < 0):
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		rightScore += 1
	if (ballPosition.x > screenSize.x):
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		leftScore += 1
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
