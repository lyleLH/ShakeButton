//
//  ViewController.m
//  ShakeButton
//
//  Created by 刘浩 on 2017/8/30.
//  Copyright © 2017年 刘浩. All rights reserved.
//

#import "ViewController.h"
#import "AnimationNumberView.h"
@interface ViewController ()
@property (nonatomic,strong)AnimationNumberView * label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton * button  = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"hug_nomal"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(200 ,300 , 30, 30)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    AnimationNumberView * label = [[AnimationNumberView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMidY(button.frame)-7.5, 25, 15)];
    label.numberFont = [UIFont systemFontOfSize:12];
    label.numberColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
      label.currentNumber = @"19";
    self.label =label;
    [self.view addSubview:label];
}

- (void)buttonAction:(UIButton *)button {
    button.selected = !button.selected;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
    if(button.selected){
        CAShapeLayer *pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = button.bounds;
        
        pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
        pulseLayer.fillColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.69 alpha:1.0].CGColor;//填充色
        pulseLayer.opacity = 0.0;
        pulseLayer.lineWidth = 1;
        //可以复制layer
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = button.bounds;
        replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay = 1;//复制副本之间的延迟
        [replicatorLayer addSublayer:pulseLayer];
        [button.layer addSublayer:replicatorLayer];
        
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(0.3);
        opacityAnima.toValue = @(0.0);
        
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
        
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[opacityAnima, scaleAnima];
        groupAnima.duration = 0.5;
        groupAnima.autoreverses = NO;
        groupAnima.repeatCount = 1;
        [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        [button setImage:[UIImage imageNamed:button.selected?@"hug_pressed":@"hug_nomal"] forState:UIControlStateNormal];
        self.label.numberColor =button.selected?[UIColor colorWithRed:0.3 green:0.8 blue:0.69 alpha:1.0]:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    }];
    NSInteger newCount =button.selected? [self.label.currentNumber integerValue]+1: [self.label.currentNumber integerValue]-1;
    self.label.currentNumber  = [NSString stringWithFormat:@"%ld",newCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
