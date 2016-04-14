//
//  SBTagListView.m
//  SBTagListView
//
//  Created by yangjingchao on 16/4/14.
//  Copyright © yangjingchao. All rights reserved.
//

#import "SBTagListView.h"
#import "UIColor-Expanded.h"


@interface SBTagListView()
@property (assign, nonatomic) NSUInteger linesOfTags;

@end
@implementation SBTagListView

- (instancetype)initWithWidth:(CGFloat)width contentArray:(NSMutableArray *)array {
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    if (self) {
        self.contentArray = array;
        self.tagsArray = [self generateTagsByStrings:self.contentArray];
        self.linesOfTags = [self generateLinesOfTags];
        self.frame = CGRectMake(0, 0, width, self.linesOfTags * 39);
    }
    return self;
}

#pragma mark view 
- (void)layoutSubviews {
    [self layoutTags];
}

- (void)reloadTags {
    NSArray *subviews = [self subviews];
    for (UIView *subvie in subviews) {
        [subvie removeFromSuperview];
    }
    [self layoutTags];
}

- (void)layoutTags {
    NSUInteger totalLines = 1;
    CGFloat currentTotalWidth = 0;
    for (NSUInteger i = 0; i < self.tagsArray.count; ++i) {
        SBTag *tag = self.tagsArray[i];
        currentTotalWidth += tag.frame.size.width + 4;
        if (currentTotalWidth >= self.frame.size.width) {
            if (currentTotalWidth == self.frame.size.width) {
                tag.frame = CGRectMake(currentTotalWidth - tag.frame.size.width, (totalLines -1) * 39, tag.frame.size.width, tag.frame.size.height);
                [self addSubview:tag];
            }
            totalLines++;
            if (currentTotalWidth > self.frame.size.width) {
                --i;
            }
            currentTotalWidth = 0;
            
        }else {
            tag.frame = CGRectMake(currentTotalWidth - tag.frame.size.width, (totalLines -1) * 39, tag.frame.size.width, tag.frame.size.height);
            [self addSubview:tag];
        }
    }
}


- (NSUInteger)generateLinesOfTags {
    NSUInteger totalLines = 1;
    CGFloat currentTotalWidth = 0;
    for (NSUInteger i = 0; i < self.tagsArray.count; ++i) {
        SBTag *tag = self.tagsArray[i];
        currentTotalWidth += tag.frame.size.width + 4;
        if (currentTotalWidth >= self.frame.size.width) {
            totalLines++;
            if (currentTotalWidth > self.frame.size.width) {
                --i;
            }
            currentTotalWidth = 0;
        }
    }
    return totalLines;
}

- (void)removeTagAtIndex:(NSUInteger)index {
    [self.tagsArray removeObject:[self desequeseTagAtIndex:index]];
    [self reloadTags];
}


- (void)resizeToWidth:(CGFloat)width {
    //已经是这么宽
    if (self.frame.size.width == width) {
        return;
    }
    //宽度小于一个tag，不能这么玩
    for (SBTag * tag in self.tagsArray) {
        if (width <= tag.frame.size.width) {
            NSLog(@"can not resize to the width smaller than a tag");
            return;
        }
    }
    //高度重新计算,比现在大要show出来
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    CGFloat height = [self generateLinesOfTags] * 39;
    if (height < self.frame.size.height) {
        height = self.frame.size.height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    [self reloadTags];
}

#pragma mark data
- (NSMutableArray *)generateTagsByStrings:(NSMutableArray *)array {
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    NSUInteger i = 0;
    @autoreleasepool {
        for (NSString *tagString in self.contentArray) {
            SBTag *tag = [[SBTag alloc] initWithText:tagString];
            tag.index = i;
            [tag addTarget:self action:@selector(didTappedTag:) forControlEvents:UIControlEventTouchUpInside];
            if (tag.frame.size.width > self.frame.size.width) {
                NSLog(@"can not create a taglistview that the width smaller than his tags");
            }else {
                [resultArray addObject:tag];
                ++i;
            }
            
            
        }
    }
    return resultArray;
}

#pragma SEL
- (void)didTappedTag:(SBTag *)sender {
    
//此处为单选而专门写的代码处理判断------------------------------
    if(sender.index != self.oldIndex){
        //移除旧索引的tag选中效果
        NSArray *subviews = [self subviews];
        for (SBTag *subvie in subviews) {
            if (subvie.index == self.oldIndex) {
                [subvie setTagType:SBTagTypeNormal];
            }
        }
        [self layoutTags];
    }
//----------------------------------------------------
    
    if ([self.delegate respondsToSelector:@selector(didSelectTagAtIndex:Sblist:)]) {
        [self.delegate didSelectTagAtIndex:sender.index Sblist:self];
    }
}
- (SBTag *)desequeseTagAtIndex:(NSUInteger)index {
    for (SBTag *tag in self.tagsArray) {
        if (tag.index == index) {
            self.oldIndex = index;
            return tag;
        }
    }
    return nil;
}
@end

@implementation SBTag

- (instancetype)initWithText:(NSString *)text {
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(FLT_MAX, 25) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    self = [super initWithFrame:CGRectMake(0, 0, contentSize.width +20, 25)];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.90 green: 0.90 blue: 0.90 alpha: 1];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rect cornerRadius: 6];
    [color setFill];
    [rectanglePath fill];
    
    
    //// Text Drawing
    CGRect textRect = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
    {
        NSString* textContent = self.text;
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor darkGrayColor], NSParagraphStyleAttributeName: textStyle};
        
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(10, 4, self.frame.size.width - 10, self.frame.size.height) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }
    

}

- (void)setNormal {
    self.isselect = NO;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
//    self.layer.backgroundColor = [UIColor clearColor].CGColor;
}
- (void)setError {
    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3;
}

- (void)setSuccess {
    self.isselect = YES;
    self.layer.shadowColor = [UIColor colorWithHexString:@"ff5000"].CGColor;
//    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 3;
}

- (void)setTagType:(SBTagType)type {
    switch (type) {
        case SBTagTypeNormal:
            [self setNormal];
            break;
        case SBTagTypeSuccess:
            [self setSuccess];
            break;
        case SBTagTypeError:
            [self setError];
            break;
        default:
            [self setNormal];
            break;
    }
}

@end