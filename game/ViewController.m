//
//  ViewController.m
//  game
//
//  Created by luke on 2017/4/18.
//  Copyright © 2017年 imooc. All rights reserved.
//

#import "ViewController.h"
#import "IdiomModel.h"



@interface ViewController ()

@property(strong,nonatomic) NSArray * questions;

@property (weak, nonatomic) IBOutlet UIButton *tip;
@property (weak, nonatomic) IBOutlet UIButton *help;
@property (weak, nonatomic) IBOutlet UIButton *img;
@property (weak, nonatomic) IBOutlet UIButton *next;

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *round;
@property (weak, nonatomic) IBOutlet UILabel *reminder;
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void)optionsButton;
-(void)answerButton;
-(void)optionsButtonAction:(UIButton *)sender;
-(void)answerButtonAction:(UIButton *)sender;

-(void)scoreview;
-(void)roundview;
-(void)reminderview;
-(void)imageview;

-(void)nextRound;
-(void)imageTransform;

-(void)rightAlert;
-(void)wrongAlert;

- (IBAction)nextButton:(id)sender;
- (IBAction)bigImage:(id)sender;
- (IBAction)imageButton:(id)sender;

@end



// 轮数控制
int roundNumber =1;
//分数
int scoreNumber=10000;
//选项区次数按钮控制
int buttonNumber=0;

//存放选项按钮
NSMutableArray * optionsButtonArray;
//存放答案按钮
NSMutableArray * answerButtonArray;
//存放已选择的选项按钮
NSMutableArray * choice;

//存放图片
NSMutableArray * imageArray;

//大图视图
UIImageView * bigImage;




@implementation ViewController

//导入plist数据
-(NSArray *)questions{
    if (_questions==nil) {
        
        NSString * path=[[NSBundle mainBundle]pathForResource:@"questions" ofType:@"plist"];
        
        NSArray * dictArr=[NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray * mutArr=[NSMutableArray array];
        
        for (NSDictionary * dict in dictArr) {
            IdiomModel * model =[[IdiomModel alloc]init];
            model.answer=dict[@"answer"];
            model.title=dict[@"title"];
            model.options=dict[@"options"];
            [mutArr addObject:model];
        }
        _questions=mutArr;
    }
    return _questions;
}


//载入
- (void)viewDidLoad {
    [super viewDidLoad];
   
    optionsButtonArray = [[NSMutableArray alloc]init];
    answerButtonArray = [[NSMutableArray alloc]init];
    choice=[[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    
    [self optionsButton];
    [self answerButton];
    [self scoreview];
    [self roundview];
    [self reminderview];
    [self imageview];
}


//选项区按钮
-(void)optionsButton{
    
    // 清空选项区
    if (optionsButtonArray!=nil || optionsButtonArray.count!=0) {
        for (int i=0; i<optionsButtonArray.count; i++) {
            [[optionsButtonArray objectAtIndex:i] removeFromSuperview];
        }
        [optionsButtonArray removeAllObjects];
    }
    
    // 创建选项区按钮
    for (int i=0; i<3; i++) {
        int numy=397+60*i;
        for (int j=0; j<7; j++) {
            int numx=11.875+51.875*j;
            UIButton * button =[[UIButton alloc]initWithFrame:CGRectMake(numx, numy, 40, 40)];
            button.backgroundColor=[UIColor grayColor];
            [button addTarget:self action:@selector(optionsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            [optionsButtonArray addObject:button];
        }
    }
    
    // 设置选项区按钮标签
    IdiomModel * model =self.questions[roundNumber-1];
    NSArray * optionsButtonTextArray = model.options;
    
    for (int i=0; i<21; i++) {
        UIButton * button = [optionsButtonArray objectAtIndex:i];
        NSString * item = [optionsButtonTextArray objectAtIndex:i];
        [button setTitle:item forState:UIControlStateNormal];
    }
 
    buttonNumber=0;
    [choice removeAllObjects];
}


//选项区按钮操作
-(void)optionsButtonAction:(UIButton *)sender{
   
    buttonNumber+=1;
    
    IdiomModel * model = self.questions[roundNumber-1];
    NSString * item = model.answer;
    
    if (buttonNumber<=item.length) {
        [[answerButtonArray objectAtIndex:buttonNumber-1] setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        [choice insertObject:sender atIndex:buttonNumber-1];
        [sender removeFromSuperview];
    }
   
    //判断
    if (buttonNumber == item.length) {
        
        NSMutableString * myAnswer = [[NSMutableString alloc]init];
        
        for (int i=0; i<buttonNumber; i++) {
            UIButton * button = [choice objectAtIndex:i];
            [myAnswer appendString:button.titleLabel.text];
        }
        
        if ([myAnswer isEqualToString:item]) {
            scoreNumber+=10000;
            [self scoreview];
            [self rightAlert];
            if (roundNumber != 10) {
                [self nextRound];
            }
        }else{
            scoreNumber-=1000;
            [self scoreview];
            [self wrongAlert];
        }
    }
}


//答案区按钮操作
-(void)answerButtonAction:(UIButton *)sender{
    [sender setTitle:@"" forState:UIControlStateNormal];
    NSInteger a = [answerButtonArray indexOfObject:sender];
    [self.view addSubview:[choice objectAtIndex:a]];
    buttonNumber-=1;
}


//答案区按钮
-(void)answerButton{
   
    // 清空答案区
    if (answerButtonArray!=nil || answerButtonArray.count!=0) {
        for (int i=0; i<answerButtonArray.count; i++) {
            [[answerButtonArray objectAtIndex:i] removeFromSuperview];
        }
        [answerButtonArray removeAllObjects];
    }
  
    // 创建答案区按钮
    IdiomModel * model = self.questions[roundNumber-1];
    NSString * item = model.answer;
    unsigned long num=item.length;
   
    for (int i=0; i<num; i++) {
        unsigned long numx=(375-num*40-(num-1)*25)/2+65*i;
        UIButton * button =[[UIButton alloc]initWithFrame:CGRectMake(numx, 313, 40, 40)];
        button.backgroundColor=[UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(answerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [answerButtonArray addObject:button];
    }
}


//正确提示
-(void)rightAlert{
    UIAlertController * rightAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你答对了" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * rightAction = [UIAlertAction actionWithTitle:@"点击取消" style:UIAlertActionStyleCancel handler:nil];
    [rightAlert addAction:rightAction];
    [self presentViewController:rightAlert animated:YES completion:nil];
}


//错误提示
-(void)wrongAlert{
    UIAlertController * wrongAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你错了" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * wrongAction = [UIAlertAction actionWithTitle:@"再来一次" style:UIAlertActionStyleCancel handler:nil];
    [wrongAlert addAction:wrongAction];
     [self presentViewController:wrongAlert animated:YES completion:nil];
}


//分数显示
-(void)scoreview{
    NSString * scoreNumberString = [NSString stringWithFormat:@"%d",scoreNumber];
    self.score.text=scoreNumberString;
}


//轮数显示
-(void)roundview{
    NSMutableString * roundNumberString=[NSMutableString stringWithFormat:@"%d",roundNumber];
    [roundNumberString appendString:@"/10"];
    self.round.text=roundNumberString;
}


//提示显示
-(void)reminderview{
    IdiomModel * model = self.questions[roundNumber-1];
    self.reminder.text=model.title;
}


//图片显示
-(void)imageview{
    self.image.layer.borderColor=[UIColor cyanColor].CGColor;
    self.image.layer.borderWidth=6;
    [self.view bringSubviewToFront:self.image];
    
    UIImage * image1 = [UIImage imageNamed:@"1.jpg"];
    [imageArray addObject:image1];
    
    UIImage * image2 = [UIImage imageNamed:@"2.jpg"];
    [imageArray addObject:image2];
    
    UIImage * image3 = [UIImage imageNamed:@"3.jpg"];
    [imageArray addObject:image3];
    
    UIImage * image4 = [UIImage imageNamed:@"4.jpg"];
    [imageArray addObject:image4];
    
    UIImage * image5 = [UIImage imageNamed:@"5.jpg"];
    [imageArray addObject:image5];
    
    UIImage * image6 = [UIImage imageNamed:@"6.jpg"];
    [imageArray addObject:image6];
    
    UIImage * image7 = [UIImage imageNamed:@"7.jpg"];
    [imageArray addObject:image7];
    
    UIImage * image8 = [UIImage imageNamed:@"8.jpeg"];
    [imageArray addObject:image8];
    
    UIImage * image9 = [UIImage imageNamed:@"9.jpg"];
    [imageArray addObject:image9];
    
    UIImage * image10 = [UIImage imageNamed:@"10.jpeg"];
    [imageArray addObject:image10];
    
    self.image.image=[imageArray objectAtIndex:roundNumber-1];
    self.image.contentMode=UIViewContentModeScaleToFill;
}


//下一题按钮
- (IBAction)nextButton:(id)sender {
    [self nextRound];
}


//下一题操作
-(void)nextRound{
    
    if (roundNumber>0 && roundNumber<10) {
        roundNumber+=1;
    }
    
    [self optionsButton];
    [self answerButton];
    [self scoreview];
    [self roundview];
    [self reminderview];
    [self imageview];

}


//大图按钮
- (IBAction)bigImage:(id)sender {
    [self imageTransform];
}


//图片按钮
- (IBAction)imageButton:(id)sender {
    [self imageTransform];
}


//图片放大操作
-(void)imageTransform{
    if (bigImage == nil) {
        bigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 114, 375, 470)];
        bigImage.layer.borderColor=[UIColor cyanColor].CGColor;
        bigImage.layer.borderWidth=6;
        bigImage.image=[imageArray objectAtIndex:roundNumber-1];
        bigImage.contentMode=UIViewContentModeScaleToFill;
        [self.view addSubview:bigImage];
        [self.view bringSubviewToFront:bigImage];
    }else{
        [bigImage removeFromSuperview];
        bigImage=nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
