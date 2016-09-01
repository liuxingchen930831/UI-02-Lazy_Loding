//
//  ViewController.m
//  UI-02
//
//  Created by liuxingchen on 16/8/30.
//  Copyright © 2016年 Liuxingchen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *shopView;
/** 数据源 */
@property(nonatomic,strong)NSArray * shopsArray ;
/** 添加 */
@property(nonatomic,strong)UIButton * addBtn ;
/** 删除 */
@property(nonatomic,strong)UIButton * removeBtn ;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

//一进来就会调用viewDidLoad方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addBtn = [self frame:CGRectMake(50, 50, 70, 70) normalImage:@"add" highlightedImage:@"add_highlighted" disabledImage:@"add_disabled" tag:10 action:@selector(add:)];
    
    self.removeBtn = [self frame:CGRectMake(250, 50, 70, 70) normalImage:@"remove" highlightedImage:@"remove_highlighted" disabledImage:@"remove_disabled" tag:20 action:@selector(remove:)];
    self.removeBtn.enabled = NO;
}
/**
 - 什么是懒加载
	- 所谓懒加载就是用到的时候再去加载，并且只会加载一次初始化方法
 - 懒加载的原理
	- 懒加载的原理其实就是重写get方法,并且在懒加载的时候判断一下，当前对象是否是空如果是空就对当前对象进行初始话或其他操作，如果不是就把当前对象return出去
 */
-(NSArray *)shopsArray
{
    
    if (_shopsArray ==nil) {
        NSLog(@"----");
        NSString *path = [[NSBundle mainBundle]pathForResource:@"shops" ofType:@"plist"];
        _shopsArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _shopsArray;
    
}

-(UIButton *)frame:(CGRect) frame
 normalImage:(NSString *) normalImage
highlightedImage:(NSString *) highlightedImage
disabledImage:(NSString *) disabledImage
          tag:(NSInteger) tag
       action:(SEL) action
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:disabledImage] forState:UIControlStateDisabled];
    btn.tag = tag;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

-(void)add:(UIButton *)btn;
{
    CGFloat shopW = 70;
    CGFloat shopH = 90;
    
    int cols = 3;
    
    CGFloat colsMargin = (self.shopView.frame.size.width - cols * shopW)/(cols-1);
    
    NSUInteger index = self.shopView.subviews.count;
    
    NSUInteger col = index %cols ;
    CGFloat shopX = col *(colsMargin + shopW);
    
    CGFloat rowMargin = 10;
    NSUInteger row = index /cols ;
    
    CGFloat shopY = row *(rowMargin +shopH);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(shopX, shopY, shopW,shopH)];
    view.backgroundColor = [UIColor redColor];
    [self.shopView addSubview:view];
    
    
    NSDictionary *dict = self.shopsArray[index];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, shopW, shopW)];
    imageView.image = [UIImage imageNamed:dict[@"icon"]];
    [view addSubview:imageView];
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(0, shopW, shopW, shopH-shopW)];
    label.text = dict[@"name"];
    label.backgroundColor = [UIColor blueColor];
    //设置字体大小
    label.font = [UIFont systemFontOfSize:13];
    //设置字体居中
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [self ButtonState];
}
-(void)remove:(UIButton *)btn;
{
    [self.shopView.subviews.lastObject removeFromSuperview];
    [self ButtonState];
}
-(void)ButtonState
{
    self.addBtn.enabled = (self.shopView.subviews.count < self.shopsArray.count);
    self.removeBtn.enabled = (self.shopView.subviews.count > 0);
    
    NSString *text = nil;
    if (self.addBtn.enabled == NO) {
        text = @"加满了别买了";
    }else if (self.removeBtn.enabled ==NO){
        text = @"删光了买买买";
    }
    if (text==nil)return;
    self.label.alpha = 1.0;
    self.label.text = text;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.label.alpha = 0.0;
    });
    
}

@end
