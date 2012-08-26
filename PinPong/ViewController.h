//
//  ViewController.h
//  PinPong
//
//  Created by X on 25.08.12.
//  Copyright (c) 2012 X. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AIMoveSpeed 4

typedef enum {
    Paused,
    Running
} GameStates;

@interface ViewController : UIViewController {
    GameStates gameState;
    CGPoint ballSpeed;
    int myScore;
    int enemyScore;
    CGFloat ballWidth;
    CGFloat ballHeight;
    CGFloat boardHeight;
    CGFloat boardWidth;
}

@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property (strong, nonatomic) IBOutlet UIImageView *myBoard;
@property (strong, nonatomic) IBOutlet UIImageView *enemyBoard;
@property (strong, nonatomic) IBOutlet UIButton *start;
@property (strong, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *enemyScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *victoryText;

@end