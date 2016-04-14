//
//  SBTagListView.h
//  SBTagListView
//
//  Created by yangjingchao on 16/4/14.
//  Copyright © yangjingchao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger{
    SBTagTypeNormal = 0,
    SBTagTypeError,
    SBTagTypeSuccess,
}SBTagType;

@protocol SBTagListViewDelegate <NSObject>

@optional
- (void)didSelectTagAtIndex:(NSUInteger)index Sblist:(UIView *)sbview;

@end



@interface SBTag : UIButton

@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) NSUInteger index;
@property(assign,nonatomic)BOOL isselect;


- (instancetype)initWithText:(NSString *)text;
- (void)setTagType:(SBTagType)type;
@end



@interface SBTagListView : UIView

@property (strong, nonatomic) NSMutableArray *contentArray;
@property (strong, nonatomic) NSMutableArray *tagsArray;
@property (assign, nonatomic) id<SBTagListViewDelegate> delegate;
@property(nonatomic,assign)NSUInteger oldIndex;

- (instancetype)initWithWidth:(CGFloat)width contentArray:(NSMutableArray *)array;

- (SBTag *)desequeseTagAtIndex:(NSUInteger)index;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)resizeToWidth:(CGFloat)width;
@end
