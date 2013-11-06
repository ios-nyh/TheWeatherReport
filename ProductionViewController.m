//
//  ProductionViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-10-18.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "ProductionViewController.h"
#import "ProductionCell.h"
#import "PostDataTools.h"
#import "MBProgressHUD.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface ProductionViewController ()<MBProgressHUDDelegate>
{
    BOOL result; //判断是否执行要滚动到最后一个cell位置的方法
}

@property (retain,nonatomic) MBProgressHUD *progressHUD;

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
    [_customTV release];
    [_bgView release];
    [_txt release];
    
    [_contentArray release];
    [_dateArray release];
    
    [_HD release];
    [_progressHUD release];
    
    
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
    
    //添加表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 44 - 20 - 60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bouncesZoom = YES;
    self.customTV = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
   
    //初始化存储建议内容数组
    //内容
    NSMutableArray *contentArray = [NSMutableArray array];
    self.contentArray = contentArray;
    //时间
    NSMutableArray *dateArray = [NSMutableArray array];
    self.dateArray = dateArray;

    //初始化异步下载
    HTTPDownload *hd = [[[HTTPDownload alloc]init]autorelease];
    hd.delegate = self;
    self.HD = hd;
    
    //开始下载
    [self.HD downloadFromURL:GET_COMMENT_LIST_API];
    //加入指示视图
    [self MBProgressHUDView];
    
    //发表框
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 44 - 20 - 60, WIDTH, 60)];
    bgView.backgroundColor = [UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0];
    self.bgView= bgView;
    [self.view addSubview:bgView];
    
    UITextField *txt = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, WIDTH - 20, 40)];
    txt.borderStyle = UITextBorderStyleLine;
    txt.backgroundColor = [UIColor whiteColor];
    txt.delegate = self;
    self.txt = txt;
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
    if (self.txt.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"内容不能为空！"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        [alert release];
        
    } else {
        
        NSString *argument = [NSString stringWithFormat:PUBLISH_COMMENT_ARGUMENT,self.txt.text];
        
        NSString *api = [NSString stringWithFormat:@"%@",PUBLISH_COMMENT_API];
        
        NSString *msg = [PostDataTools postDataWithPostArgument:argument andAPI:api];

        if ([msg isEqualToString:@"添加成功"]){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功！"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
            
            [self.HD downloadFromURL:GET_COMMENT_LIST_API];
            //判断是否要滚动到最后一个cell位置
            result = YES;
        }
    }
}

#pragma mark - HTTPDownload method 

- (void)downloadDidFinishLoading:(HTTPDownload *)hd
{
    if (self.HD.mData) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.HD.mData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"下载内容：---- >%@",dic);
        
       
        [self.contentArray removeAllObjects];
        [self.dateArray removeAllObjects];

        for (NSDictionary *subDic in dic) {
            
            NSString *content = [subDic objectForKey:@"comment"];
            NSString *date = [subDic objectForKey:@"times"];
            
            [self.contentArray addObject:content];
            [self.dateArray addObject:date];
        }
    }
    
    //下载完成后，重载数据
    [self.customTV reloadData];
    //停止指示动画
    [self hudWasHidden:self.progressHUD];
    
    //滚动到最后一行
    if (result) {
        NSInteger row = [self.contentArray count] - 1;
        NSLog(@"row indexPath -- >%d",row);
        //界面展现好之后如果客户这一栏有数据，则自动选中第一栏
        NSIndexPath *first = [NSIndexPath indexPathForRow:row inSection:0];
        [self.customTV selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)downloadDidFail:(HTTPDownload *)hd
{
    NSLog(@"download fail %@ ！",hd);
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *content = nil;
    UILabel *date = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        //取消点击cell时候的效果
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //评论内容
        content = [[[UILabel alloc] initWithFrame:CGRectZero]autorelease];
        [content setLineBreakMode:NSLineBreakByWordWrapping];
        [content setNumberOfLines:0];
//        content.textAlignment = NSTextAlignmentRight;
        [content setMinimumScaleFactor:FONT_SIZE];
        [content setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        content.backgroundColor = [UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0];
        [content setTag:1];
//        [[content layer] setBorderWidth:2.0f]; //设置边框
        [[cell contentView] addSubview:content];
        
        
        //评论时间
        date = [[[UILabel alloc]init]autorelease];
        date.textColor = [UIColor lightGrayColor];
        date.textAlignment = NSTextAlignmentRight;
        [date setMinimumScaleFactor:FONT_SIZE];
        [date setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [date setTag:2];
        [cell.contentView addSubview:date];
    }
    
    NSString *text = [self.contentArray objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    // NS_DEPRECATED_IOS(2_0, 7_0, "Use -boundingRectWithSize:options:attributes:context:")
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    
//    //属性字符串1
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text];
//    content.attributedText = attrStr;
//    NSRange range = NSMakeRange(0, attrStr.length);
//    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典

//    //属性字符串2
//    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:[UIFont systemFontSize]],NSFontAttributeName,nil];
    
//    //通过属性字符串获取大小，用于计算文本绘制时占据的矩形块
//    CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    
    //内容
    if (!content){
        
        content = (UILabel*)[cell viewWithTag:1];
    }
    content.text = text;
    [content setFrame:CGRectMake(CELL_CONTENT_MARGIN, 0, size.width, MAX(size.height, 44.0f))];
    
    //日期
    if (!date) {
        date = (UILabel *)[cell viewWithTag:2];
    }
    [date setFrame:CGRectMake(CELL_CONTENT_MARGIN,  MAX(size.height, 44.0f), CELL_CONTENT_WIDTH, 20)];
    date.text = [self.dateArray objectAtIndex:indexPath.row];
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
    NSString *text = [self.contentArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
    
    //iOS7中，此方法被弃用，暂时用着
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}


//点击textField时，tableView往上移动
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int offset = 216;//键盘高度216
    
    NSLog(@"offset的高度：%d",offset);
    
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动 offset 个单位
    
    self.customTV.frame = CGRectMake(0.0f, - offset, WIDTH, self.customTV.frame.size.height);
    
    [UIView commitAnimations];
    
    
    NSInteger rowCount = [self.contentArray count] - 1;
    if (rowCount > 1) {
        
        //界面展现好之后如果客户这一栏有数据，则自动选中第一栏
        NSIndexPath *first = [NSIndexPath indexPathForRow:rowCount inSection:0];
        [self.customTV selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];

    self.customTV.frame =CGRectMake(0, 0, WIDTH, self.customTV.frame.size.height);
    
    [UIView commitAnimations];

}


#pragma mark - 指示视图方法

- (void)MBProgressHUDView
{
    //显示加载等待框
    
    MBProgressHUD *progressHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    
    self.progressHUD = progressHUD;
    
//    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    
    [self.view addSubview:self.progressHUD];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
//    self.progressHUD.labelText = @"加载中...";
    
    [self.progressHUD show:YES];
}

/**
 *  MBProgress Block 形式
 */
- (void)showProgressDialog {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD = HUD;
    [self.view addSubview:HUD];
    HUD.labelText = @"正在加载";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        float progress = 0.0f;
        while (progress < 1.0f){
            progress += 0.01f;
            HUD.progress = progress;
            usleep(50000);
        }
    } completionBlock:^{
        
        [self.progressHUD removeFromSuperview];
        [self.progressHUD release];
         self.progressHUD = nil;
    }];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    // Remove HUD from screen when the HUD was hidded
    
    [self.progressHUD removeFromSuperview];
    
    [_progressHUD release];
    
    _progressHUD = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
