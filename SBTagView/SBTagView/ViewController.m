//
//  ViewController.m
//  SBTagView
//
//  Created by YangJingchao on 16/4/14.
//  Copyright © 2016年 YangJingchao. All rights reserved.
//

#import "ViewController.h"
#import "SBTagListView.h"
#import "UIColor-Expanded.h"
#import "UIViewController+KNSemiModal.h"



@interface ViewController ()<SBTagListViewDelegate>

@property(nonatomic,strong)UIView *AddApplyView;//新增采购view
//申请单位
@property(nonatomic,strong)UILabel *labelUnitTitle;
@property(nonatomic,strong)SBTagListView *view_UnitType;
@property(nonatomic,strong)UILabel *labelUnitLine;

//设备类型
@property(nonatomic,strong)UILabel *labelDeviceTitle;
@property(nonatomic,strong)SBTagListView *view_DeviceType;
@property(nonatomic,strong)UILabel *labelDeviceLine;

//数量
@property(nonatomic,strong)UILabel *labelNumTitle;
@property(nonatomic,strong)UIButton *btnJian;
//@property(nonatomic,strong)UILabel *labelTextNum;
@property(nonatomic,strong)UITextField *tfTextNum;
@property(nonatomic,strong)UIButton *btnJia;
@property(nonatomic,strong)UILabel *labelNumLine;

//申请人
@property(nonatomic,strong)UILabel *labelPeoPle;
@property(nonatomic,strong)UITextField *tfPeople;
@property(nonatomic,strong)UILabel *labelPeopleLine;

//电话
@property(nonatomic,strong)UILabel *labelPhone;
@property(nonatomic,strong)UITextField *tfPhone;
@property(nonatomic,strong)UILabel *labelPhoneLine;

//确定
@property(nonatomic,strong)UIButton *btnOk;

@property(nonatomic,strong)UIScrollView *mysv;


//单位列表
@property(nonatomic,strong)NSMutableArray *arrUnit;
@property(nonatomic,strong)NSMutableArray *arrType;
@property(nonatomic,strong)NSString *strTypeID;
@property(nonatomic,strong)NSString *strUnitIds;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.arrType = [[NSMutableArray alloc]initWithObjects:@"无与伦比",@"为你沉沦", nil];
    self.arrUnit = [[NSMutableArray alloc]initWithObjects:@"iPhone 6Plus",@"三星 S7", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 添加页面视图
-(IBAction)ShowTagView:(id)sender{

    //大背景view
    self.AddApplyView  = [[UIView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -100)];
    self.AddApplyView.backgroundColor = [UIColor whiteColor];
    
    //底层滚动视图
    self.mysv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.AddApplyView.frame.size.height-50)];
    [self.AddApplyView addSubview:self.mysv];
    
    
    //申请单位view
    self.view_UnitType = [[SBTagListView alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-20 contentArray:self.arrType];
    self.view_UnitType.frame = CGRectMake(10, 50, self.view_UnitType.frame.size.width,self.view_UnitType.frame.size.height);
    self.view_UnitType.tag = 100001;
    [self.mysv addSubview:self.view_UnitType];
    self.view_UnitType.delegate = self;
    
    //文字
    self.labelUnitTitle =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    self.labelUnitTitle.text = @"申请单位";
    [self.mysv addSubview:self.labelUnitTitle];
    
    //线
    _labelUnitLine =[[UILabel alloc]initWithFrame:CGRectMake(10, _view_UnitType.frame.origin.y+_view_UnitType.frame.size.height +10, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    _labelUnitLine.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.mysv addSubview:_labelUnitLine];
    
    //设备类型
    //文字
    _labelDeviceTitle =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelUnitLine.frame.origin.y + 1, 200, 30)];
    _labelDeviceTitle.text = @"设备类型";
    [self.mysv addSubview:_labelDeviceTitle];
    
    //标签
    self.view_DeviceType = [[SBTagListView alloc] initWithWidth:[UIScreen mainScreen].bounds.size.width-20 contentArray:self.arrUnit];
    self.view_DeviceType.frame = CGRectMake(10, _labelDeviceTitle.frame.origin.y+ _labelDeviceTitle.frame.size.height + 10, self.view_DeviceType.frame.size.width,self.view_DeviceType.frame.size.height);
    self.view_DeviceType.tag = 200001;
    [self.mysv addSubview:self.view_DeviceType];
    self.view_DeviceType.delegate = self;
    
    //线
    _labelDeviceLine =[[UILabel alloc]initWithFrame:CGRectMake(10, _view_DeviceType.frame.origin.y+_view_DeviceType.frame.size.height +10, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    _labelDeviceLine.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.mysv addSubview:_labelDeviceLine];
    
    //数量
    _labelNumTitle =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelDeviceLine.frame.origin.y + 10, 200, 30)];
    _labelNumTitle.text = @"数量";
    [self.mysv addSubview:_labelNumTitle];
    
    //减号
    _btnJian = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, _labelDeviceLine.frame.origin.y + 10, 30, 30)];
    [_btnJian setBackgroundImage:[UIImage imageNamed:@
                                  "按钮-"
                                  ] forState:UIControlStateNormal];
    [self.mysv addSubview:_btnJian];
    
    //数量文字
    _tfTextNum =[[UITextField alloc]initWithFrame:CGRectMake(_btnJian.frame.origin.x +_btnJian.frame.size.width+10, _labelDeviceLine.frame.origin.y + 10, 30, 30)];
    _tfTextNum.text = [NSString stringWithFormat:@"%zd",1];
    _tfTextNum.textColor =[UIColor colorWithHexString:@"ff5000"];
    _tfTextNum.textAlignment = NSTextAlignmentCenter;
    _tfTextNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.mysv addSubview:_tfTextNum];
    
    //加号
    _btnJia = [[UIButton alloc]initWithFrame:CGRectMake(_tfTextNum.frame.origin.x + _tfTextNum.frame.size.width +10,_labelDeviceLine.frame.origin.y + 10, 30, 30)];
    [_btnJia setBackgroundImage:[UIImage imageNamed:@
                                 "按钮+"
                                 ] forState:UIControlStateNormal];
    [self.mysv addSubview:_btnJia];
    
    
    _labelNumLine =[[UILabel alloc]initWithFrame:CGRectMake(10, _tfTextNum.frame.origin.y +_tfTextNum.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    _labelNumLine.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.mysv addSubview:_labelNumLine];
    
    
    //申请人
    _labelPeoPle =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelNumLine.frame.origin.y + 10, 200, 30)];
    _labelPeoPle.text = @"申请人";
    [self.mysv addSubview:_labelPeoPle];
    
    _tfPeople =[[UITextField alloc]initWithFrame:CGRectMake(70, _labelNumLine.frame.origin.y + 10, [UIScreen mainScreen].bounds.size.width - 70 -10, 30)];
    _tfPeople.placeholder =@"请填写申请人姓名";
    _tfPeople.borderStyle = UITextBorderStyleRoundedRect;
    _tfPeople.font =[UIFont systemFontOfSize:13];
    [self.mysv addSubview:_tfPeople];
    
    _labelPeopleLine =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelPeoPle.frame.origin.y + _labelPeoPle.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    _labelPeopleLine.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.mysv addSubview:_labelPeopleLine];
    
    //电话
    _labelPhone =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelPeopleLine.frame.origin.y + 10, 200, 30)];
    _labelPhone.text = @"电话";
    [self.mysv addSubview:_labelPhone];
    
    _tfPhone =[[UITextField alloc]initWithFrame:CGRectMake(70, _labelPeopleLine.frame.origin.y + 10,  [UIScreen mainScreen].bounds.size.width - 70 -10, 30)];
    _tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    _tfPhone.borderStyle = UITextBorderStyleRoundedRect;
    _tfPhone.placeholder =@"请填写电话";
    _tfPhone.font =[UIFont systemFontOfSize:13];
    [self.mysv addSubview:_tfPhone];
    
    _labelPhoneLine =[[UILabel alloc]initWithFrame:CGRectMake(10, _labelPhone.frame.origin.y + _labelPhone.frame.size.height + 10, [UIScreen mainScreen].bounds.size.width - 20, 1)];
    _labelPhoneLine.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    [self.mysv addSubview:_labelPhoneLine];
    
    
    [self.mysv setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, _labelPhoneLine.frame.origin.y + 10)];
    
    //确定
    _btnOk =[[UIButton alloc]initWithFrame:CGRectMake(0, _AddApplyView.frame.size.height- 50,[UIScreen mainScreen].bounds.size.width, 50)];
    [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
    [_btnOk.titleLabel setTextColor:[UIColor whiteColor]];
    _btnOk.backgroundColor =[UIColor colorWithHexString:@"ff5000"];
    [self.AddApplyView addSubview:_btnOk];
    
    
    UIImageView *backgroundV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
    [self presentSemiView:self.AddApplyView withOptions:@{KNSemiModalOptionKeys.backgroundView:backgroundV}];
}


#pragma mark 点击标签
- (void)didSelectTagAtIndex:(NSUInteger)index Sblist:(UIView *)sbview{
    if (sbview.tag == 100001) {
        
        SBTag *tag = [self.view_UnitType desequeseTagAtIndex:index];
        if (tag.isselect) {
            self.strUnitIds =@"";
            [tag setTagType:SBTagTypeNormal];
        }else{
            self.strUnitIds = [self.arrType objectAtIndex:tag.index];
            [tag setTagType:SBTagTypeSuccess];
        }
        NSLog(@"第一个：%@",self.strUnitIds);
    }else{
        SBTag *tag = [self.view_DeviceType desequeseTagAtIndex:index];
        if (tag.isselect) {
            self.strTypeID = @"";
            [tag setTagType:SBTagTypeNormal];
        }else{
            self.strTypeID = [self.arrUnit objectAtIndex:tag.index];
            [tag setTagType:SBTagTypeSuccess];
        }
        NSLog(@"第二个：%@",self.strTypeID);
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
