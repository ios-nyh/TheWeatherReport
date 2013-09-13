//
//  DisclaimerViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, WIDTH,HEIGHT - 44 - 5)];
    [txtView setEditable:NO];
    [self.view addSubview:txtView];
    txtView.text = @"1、用户违反本《协议》或相关的服务条款的规定，导致或产生的任何第三方主张的任何索赔、要求或损失，包括合理的律师费，用户同意赔偿华信互动与合作公司、关联公司，并使之免受损害。\n\n2、用户因第三方如电信部门的通讯线路故障、技术问题、网络、电脑故障、系统不稳定性及其他各种不可抗力原因而遭受的一切损失，华信互动及合作单位不承担责任。\n\n3、因技术故障等不可抗事件影响到服务的正常运行的，华信互动及合作单位承诺在第一时间内与相关单位配合，及时处理进行修复，但用户因此而遭受的一切损失，华信互动及合作单位不承担责任。\n\n4、 本服务同大多数互联网服务一样，受包括但不限于用户原因、网络服务质量、社会环境等因素的差异影响，可能受到各种安全问题的侵扰，如他人利用用户的资料， 造成现实生活中的骚扰；用户下载安装的其它软件或访问的其他网站中含有“特洛伊木马”等病毒，威胁到用户的计算机信息和数据的安全，继而影响本服务的正常 使用等等。用户应加强信息安全及使用者资料的保护意识，要注意加强密码保护，以免遭致损失和骚扰。\n\n5、用户须明白，使用本服务因涉及Internet服务，可能会受到各个环节不稳定因素的影响。因此，本服务存在因不可抗力、计算机病毒或黑客攻击、系统 不稳定、用户所在位置、用户关机以及其他任何技术、互联网络、通信线路原因等造成的服务中断或不能满足用户要求的风险。用户须承担以上风险，墨迹风云公司不作担保。对因此导致用户不能发送和接受阅读信息、或接发错信息，互信互动公司不承担任何责任。\n\n6、用户须明白，在使用本服务过程中存在有来自任何他人的包括威胁性的、诽谤性的、令人反感的或非法的内容或行为或对他人权利的侵犯（包括知识产权）的匿 名或冒名的信息的风险，用户须承担以上风险，互信互动公司和合作公司对本服务不作任何类型的担保，不论是明确的或隐含的，包括所有有关信息真实性、适商 性、适于某一特定用途、所有权和非侵权性的默示担保和条件，对因此导致任何因用户不正当或非法使用服务产生的直接、间接、偶然、特殊及后续的损害，不承担 任何责任。\n\n7、互信互动公司定义的信息内容包括：文字、软件、声音、相片、录像、图表；在广告中全部内容；墨迹风云公司为用户提供的商业信息，所有这些内容受版权、 商标权、和其它知识产权和所有权法律的保护。所以，用户只能在华信互动公司和广告商授权下才能使用这些内容，而不能擅自复制、修改、编纂这些内容、或创造 与内容有关的衍生产品。\n\n8、在任何情况下，华信互动公司均不对任何间接性、后果性、惩罚性、偶然性、特殊性或刑罚性的损害，包括因用户使用华信互动天气服务而遭受的利润损失，承担责 任（即使华信互动天气已被告知该等损失的可能性亦然）。尽管本协议中可能含有相悖的规定，华信互动公司对您承担的全部责任，无论因何原因或何种行为方式，始终 不超过您在成员期内因使用华信互动天气服务而支付给华信互动公司的费用(如有)。\n\n9、就下列相关事宜的发生，华信互动不承担任何法律责任：\n(1) 华信互动根据法律规定或相关政府的要求提供您的个人信息；\n(2) 由于您将用户密码告知他人或与他人共享注册帐户，由此导致的任何个人信息的泄漏，或其他非因华信互动原因导致的个人信息的泄漏； (3) 任何第三方根据华信互动各服务条款及声明中所列明的情况使用您的个人信息，由此所产生的纠纷；\n(4) 任何由于黑客攻击、电脑病毒侵入或政府管制而造成的暂时性网站关闭；\n(5) 因不可抗力导致的任何后果；\n(6) 华信互动在各服务条款及声明中列明的使用方式或免责情形。\n";
    
    [txtView setFont:[UIFont systemFontOfSize:14.0f]];
    [txtView release];

}

//自定义返回按钮
- (void)backLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
