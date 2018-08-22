extends Node2D

export var playerSpeed = 400; #px
export var initialBallSpeed = 100; #px
export var ballSpeedIncreaseAmount = 1.2; #px
var screenSize
var padSize
var ballDirection = Vector2(-1, 0.0)
var ballSpeed = initialBallSpeed;
var leftScore = 0
var rightScore = 0
var maxBallSpeed = 600

func _ready():
	print("Game initiated.")
	screenSize = get_viewport_rect().size
	padSize = get_node("rightPlayer").texture.get_size()
	set_process(true)
	pass

func _process(delta):
	#Colliders
	var leftColide = Rect2(get_node("leftPlayer").position - padSize*0.5, padSize)
	var rightColide = Rect2(get_node("rightPlayer").position - padSize*0.5, padSize)
	
	#ball position

	var ballPosition = get_node("ball").position
	
	ballPosition += ballDirection * ballSpeed * delta
	
	if ((ballPosition.y < 0 and ballDirection.y < 0) or (ballPosition.y > screenSize.y and ballDirection.y > 0)):
		ballDirection.y = -ballDirection.y
		
	if (leftColide.has_point(ballPosition) or rightColide.has_point(ballPosition)):
		ballDirection.x = -ballDirection.x
		ballDirection.y =  randf() * 2 -1
		ballDirection = ballDirection.normalized()
		
		if (ballSpeed < maxBallSpeed): 
			ballSpeed *= ballSpeedIncreaseAmount
		
	# reset ball if it leaves the screen
	if (ballPosition.x < 0):
		print("right player scored, reset ball position")
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		rightScore += 1
	if (ballPosition.x > screenSize.x):
		print("left player scored, reset ball position")
		ballPosition = screenSize * 0.5
		ballSpeed = initialBallSpeed
		ballDirection.x = -ballDirection.x
		leftScore += 1
	
	#Control left player movement
	var leftPlayerPosition = get_node("leftPlayer").position
	if (leftPlayerPosition.y > 0 and Input.is_action_pressed("left_up")):
		leftPlayerPosition.y += -playerSpeed * delta
		
	if (leftPlayerPosition.y < screenSize.y and Input.is_action_pressed("left_down")):
		leftPlayerPosition.y += playerSpeed * delta
	
	
	#Control right player movement
	var rightPlayerPosition = get_node("rightPlayer").position
	if (rightPlayerPosition.y > 0 and Input.is_action_pressed("ui_up")):
		rightPlayerPosition.y += -playerSpeed * delta
		
	if (rightPlayerPosition.y < screenSize.y and Input.is_action_pressed("ui_down")):
		rightPlayerPosition.y += playerSpeed * delta
	

	#set all new variables values
	get_node("ball").position = ballPosition
	get_node("leftPlayer").position = leftPlayerPosition
	get_node("rightPlayer").position = rightPlayerPosition
	get_node("leftScore").set_text(str(leftScore))
	get_node("rightScore").set_text(str(rightScore))
