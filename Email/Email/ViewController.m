//
//  ViewController.m
//  Email
//
//  Created by yhj on 2017/5/24.
//  Copyright © 2017年 VG. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    UIButton *sendEmailBtn=[[UIButton alloc]initWithFrame:CGRectMake(100,200,100,30)];
    [sendEmailBtn setTitle:@"发送邮件" forState:0];
    [sendEmailBtn setTitleColor:[UIColor redColor] forState:0];
    [sendEmailBtn addTarget:self action:@selector(sendEmailBtnEvent) forControlEvents:UIControlEventTouchUpInside ];
    [self.view addSubview:sendEmailBtn];

    UIButton *sendMessageBtn=[[UIButton alloc]initWithFrame:CGRectMake(100,300,100,30)];
    [sendMessageBtn setTitle:@"发送信息" forState:0];
    [sendMessageBtn setTitleColor:[UIColor redColor] forState:0];
    [sendMessageBtn addTarget:self action:@selector(sendMessageBtnEvent) forControlEvents:UIControlEventTouchUpInside ];
    [self.view addSubview:sendMessageBtn];

}

//短信
-(void)sendMessageBtnEvent
{
    Class messageClass=(NSClassFromString(@"MFMessageComposeViewController"));

    if (messageClass!=nil)
    {
        // Check whether the current device is configured for sending SMS messages
        if ([messageClass canSendText])
        {
            [self displaySMSComposerSheet];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#define URL   @"http://www.jianshu.com/users/b090815f8f6d/following"

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *vc=[[MFMessageComposeViewController alloc]init];
    vc.messageComposeDelegate =self;
    NSString  *smsBody=[NSString stringWithFormat:@"我分享了文件给您，地址是%@",URL] ;
    vc.body=smsBody;
    [self presentViewController:vc animated:NO completion:nil];
}


-(void)sendEmailBtnEvent
{
   //  通过url的方式直接打开写邮件
//    [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"mailto:example@example.com"]];

    // 检测是否安装邮箱 用户已设置邮件帐户
    if ([MFMailComposeViewController canSendMail])
    {
        [self sendBySysMail];
    }
    else
    {
        NSLog(@"未检测到你手机上的邮件客户端");
    }
}

- (void)sendBySysMail
{
    // 邮件服务器
    MFMailComposeViewController *vc=[[MFMailComposeViewController alloc] init];
    // 设置邮件代理 委托方法，完成之后会自动调用成功或失败的方法
    [vc setMailComposeDelegate:self];
    // 设置邮件主题
    [vc setSubject:@"发送邮件"];
    // 设置收件人 单一
    // 一种方式
//    NSArray *toRecipients=[NSArray arrayWithObject:@"1787354782@qq.com"];
//    [vc setToRecipients:toRecipients];
    // 第二种方式
//    [vc setToRecipients:@[@"1787354782@qq.com"]];
    // 收件人多个时
    NSArray *toRecipients=[NSArray arrayWithObjects:@"1787354782@qq.com",@"yanghuijuan@cdnunion.com",nil];
    [vc setToRecipients:toRecipients];



    // 设置抄送人 和收件人类似 一个或者多个情况下
    [vc setCcRecipients:@[@"1787354782@qq.com"]];
    // 设置密抄送
    [vc setBccRecipients:@[@"1787354782@qq.com"]];

    //发送doc文本附件
    NSString *path1=[[NSBundle mainBundle] pathForResource:@"ty" ofType:@"doc"];
    NSData *myData1=[NSData dataWithContentsOfFile:path1];
    [vc addAttachmentData:myData1 mimeType:@"text/doc" fileName:@"ty.doc"];

    //发送图片附件
    NSString *path2=[[NSBundle mainBundle] pathForResource:@"pic" ofType:@"jpg"];
    NSData *myData2=[NSData dataWithContentsOfFile:path2];
    [vc addAttachmentData:myData2 mimeType:@"image/jpeg" fileName:@"pic.jpg"];

    //发送txt文本附件
    NSString *path3=[[NSBundle mainBundle] pathForResource:@"ty" ofType:@"txt"];
    NSData *myData3=[NSData dataWithContentsOfFile:path3];
    [vc addAttachmentData:myData3 mimeType:@"text/txt" fileName:@"ty.txt"];

    //发送pdf文档附件
    NSString *path4=[[NSBundle mainBundle]pathForResource:@"ty"ofType:@"pdf"];
    NSData *myData4=[NSData dataWithContentsOfFile:path4];
    [vc addAttachmentData:myData4 mimeType:@"file/pdf"fileName:@"ty.pdf"];


    // 设置邮件的正文内容
    NSString *emailContent=@"我是邮件内容";
    // 是否为HTML格式
    [vc setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    [vc setMessageBody:@"<html><body><p>Hello 你好 请收邮件</p><p>World！查看内容</p></body></html>" isHTML:YES];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
