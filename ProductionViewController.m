//
//  ProductionViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-10-18.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "ProductionViewController.h"

@interface ProductionViewController ()

@end

@implementation ProductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_bgView release];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //设置view背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    //定义右边发送按钮
    UIBarButtonItem *rigntBar = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:
                                 @selector(sendSuggestion)];
    rigntBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rigntBar;
    [rigntBar release];
    
    [self setUpForDismissKeyboard];
    
    //发表框
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 44 - 20 - 60, WIDTH, 60)];
    bgView.backgroundColor = [UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0];
    self.bgView= bgView;
    [self.view addSubview:bgView];
    
    UITextField *txt = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 40)];
    txt.borderStyle = UITextBorderStyleLine;
    txt.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:txt];
    
    [bgView release];
    [txt release];
    
    //注册监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

#pragma mark - 通知响应方法

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSLog(@"响应方法名： %@",NSStringFromSelector(_cmd));
    NSDictionary *info = [notification userInfo];
    NSLog(@"info  --> :%@",info);
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //copy value
    [animationDurValue getValue:&animationDuration];
    NSLog(@"animationDuration %f",animationDuration);
    //让键盘弹起的时候添加一个动画
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"动态键盘高度 ---->:%f",distanceToMove);
    [self adjustPanelsWithKeyBordHeight:distanceToMove];
    [UIView commitAnimations];
    
}

- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"键盘将要消失：%@",NSStringFromSelector(_cmd));
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    NSValue *animationDurValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    //   把animationDurvalue 值拷贝到animationDuration中
    [animationDurValue getValue:&animationDuration];
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (self.bgView) {
        
        CGRect exitBtFrame = CGRectMake(0, HEIGHT - 44 - 20 - 60 , WIDTH, 60);
        self.bgView.frame = exitBtFrame;
        
        [self.view addSubview:self.bgView];
    }
    
    [UIView commitAnimations];
}

-(void)adjustPanelsWithKeyBordHeight:(float) height
{
    if (self.bgView) {
        
        CGRect exitBtFrame = CGRectMake(0, HEIGHT - height - 44 - 20 - 60, WIDTH, 60);
        self.bgView.frame = exitBtFrame;
        
        [self.view addSubview:self.bgView];
    }
}


#pragma mark - 自定义返回按钮
- (void)backLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 发送响应按钮方法

- (void)sendSuggestion
{
    

}


#pragma mark - 键盘回收的方法

- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
    
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
