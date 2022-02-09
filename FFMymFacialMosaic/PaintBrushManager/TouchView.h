//
//  TouchView.h
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/27.
//

#import <UIKit/UIKit.h>
#import "MaskConfigManager.h"
@class TouchView,PathModel;
@protocol PTMaskTouchViewDelegate <NSObject>

- (void)maskTouchViewTouchBegin:(CGPoint)point;
- (void)maskTouchViewTouchMove:(CGPoint)point;
- (void)maskTouchViewTouchEnd:(CGPoint)point;

@end

@interface TouchView : UIView
/**
 *  路径数组
 */
@property (nonatomic,strong) NSMutableArray<PathModel *> *paths;
/**
 *  记录上一次路径 数组
 */
@property (nonatomic,strong) NSMutableArray<PathModel *> *paths_Mark;
 
@property (nonatomic,weak) id<PTMaskTouchViewDelegate> delegate;
/**
 *  touchView的初始化方法
 *
 *  @param frame       frame
 *  @param movedHandle 移动事件的回调block
 *  @param completion  触摸结束事件的回调block
 *
 *  @return TouchView Instance
 */
- (instancetype)initWithFrame:(CGRect)frame andMovedHandle:(void (^)(NSMutableArray *))movedHandle MovedCompletion:(void(^)()) completion;

@property (nonatomic, assign) BOOL canEditStatus;

@end

@interface PathModel : NSObject

@property (nonatomic,strong) NSMutableArray *points;


@property (nonatomic,assign) BlendMode blendMode;

@property (nonatomic,assign) StrokeType strokeType;

@property (nonatomic,assign) CGFloat lineWidth;

@property (nonatomic,assign) CGFloat gradientRate;

@property (nonatomic, strong) UIColor *lineColorOne;
@property (nonatomic, strong) UIColor *lineColorTwo;


@end
