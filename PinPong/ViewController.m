//
//  ViewController.m
//  PinPong
//
//  Created by X on 25.08.12.
//  Copyright (c) 2012 X. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize ball;
@synthesize myBoard;
@synthesize enemyBoard;
@synthesize start;
@synthesize myScoreLabel;
@synthesize enemyScoreLabel;
@synthesize victoryText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	gameState = Paused;
    ballSpeed = [self newBallSpeed];
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    ballWidth = ball.bounds.size.width;
    ballHeight = ballWidth; //the ball image is a square
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.ball = nil;
    self.myBoard = nil;
    self.enemyBoard = nil;
    self.start = nil;
    self.myScoreLabel = nil;
    self.enemyScoreLabel = nil;
    self.victoryText = nil;
}

-(CGPoint)newBallSpeed
{
    ballSpeed.y = (CGFloat)(arc4random() % 6 + 7);
    ballSpeed.x = (CGFloat)(arc4random() % 4 + 4);
    if (arc4random() % 2 == 0)
    {
        ballSpeed.x *= -1;
    }
    if (arc4random() % 2 == 0)
    {
        ballSpeed.y *= -1;
    }
    return ballSpeed;
}

-(IBAction)startGame
{
    myScore = 0;
    enemyScore = 0;
    ballSpeed = [self newBallSpeed];
    victoryText.text = @"";
    start.hidden = YES;
    ball.hidden = NO;
    gameState = Running;
}

-(void)resetGame
{
    myScore = 0;
    enemyScore = 0;
    ballSpeed = [self newBallSpeed];
    myScoreLabel.text = [NSString stringWithFormat: @"%d\r\n", myScore];
    enemyScoreLabel.text = [NSString stringWithFormat: @"%d\r\n", enemyScore];
    gameState = Paused;
    [self resetBallPos];
}

-(void)resetBallPos
{
    ball.center = self.view.center;
    ballSpeed = [self newBallSpeed];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPos = [touch locationInView:touch.view];
    CGPoint boardPos = CGPointMake(touchPos.x, myBoard.center.y);
    myBoard.center = boardPos;
}

-(void)gameLoop
{
    if (gameState == Running)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.05f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        ball.center = CGPointMake(ball.center.x + ballSpeed.x, ball.center.y + ballSpeed.y);
        
        //Ball bouncing from display bounds
        if (ball.center.x + ballWidth / 2 >= self.view.bounds.size.width || ball.center.x - ballWidth / 2 <= 0)
        {
            ballSpeed.x *= -1;
        }
        
        if (ball.center.y + ballHeight / 2 >= self.view.bounds.size.height || ball.center.y - ballHeight / 2 <= 0)
        {
            ballSpeed.y *= -1;
        }

        //Ball bouncing from boards
        //player's board
        if (CGRectIntersectsRect(ball.frame, myBoard.frame))
        {
            if (ball.center.y + ballHeight / 2 >= myBoard.center.y - boardHeight / 2 && ballSpeed.y > 0)
            {
                ballSpeed.y *= -1;
                ballSpeed.x += (ball.center.x - myBoard.center.x) / 10;
            }
        }
        
        //enemy's board
        if (CGRectIntersectsRect(ball.frame, enemyBoard.frame))
        {
            if (ball.center.y - ballHeight / 2 <= enemyBoard.center.y + boardHeight / 2 && ballSpeed.y < 0)
            {
                ballSpeed.y *= -1;
                ballSpeed.x += (ball.center.x - enemyBoard.center.x) / 10;
            }
        }
        
        //Enemy strategy
        if (ball.center.y <= self.view.center.y)
        {
            if(ball.center.x <= enemyBoard.center.x)
            {
                enemyBoard.center = CGPointMake(enemyBoard.center.x - AIMoveSpeed, enemyBoard.center.y);
            }
            
            if (ball.center.x > enemyBoard.center.x)
            {
                enemyBoard.center = CGPointMake(enemyBoard.center.x + AIMoveSpeed, enemyBoard.center.y);
            }
        }
        
        //Score counter
        if (ball.center.y - ballHeight / 2 <= 0)
        {
            myScore += 1;
            myScoreLabel.text = [NSString stringWithFormat: @"%d\r\n", myScore];
            [self resetBallPos];
        }
        
        if (ball.center.y + ballHeight / 2 >= self.view.bounds.size.height)
        {
            enemyScore += 1;
            enemyScoreLabel.text = [NSString stringWithFormat: @"%d\r\n", enemyScore];
            [self resetBallPos];
        }
        
        if (myScore == 3)
        {
            victoryText.text = @"Вы победили!";
            [self resetGame];
        }
        
        if (enemyScore == 3)
        {
            victoryText.text = @"Победил компьютер";
            [self resetGame];
        }
        
        [UIView commitAnimations];
    }
    else
    {
        if (start.hidden)
        {
            start.hidden = NO;
        }
        if (!ball.hidden)
        {
            ball.hidden = YES;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
