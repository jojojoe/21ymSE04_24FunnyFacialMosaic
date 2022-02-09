//
//  MSmymTouchStuffV.h
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//

#import <UIKit/UIKit.h>
#import "UIViewFrameTool.h"
#import "UIColor+ColorTool.h"
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@class WTouchStuffView,PTTouchRotateImage;
@protocol TouchStuffViewDelegate <NSObject>
@optional
- (void)viewTouchDown:(WTouchStuffView*)sender;
- (void)viewTouchUp:(WTouchStuffView*)sender;
- (void)viewTouchMoved:(WTouchStuffView*)sender;
- (void)viewDoubleClick:(WTouchStuffView *)sender;
- (void)viewSingleClick:(WTouchStuffView *)sender;
- (void)viewDeleteBtnClick:(WTouchStuffView *)sender;
- (void)viewEditBtnClick:(WTouchStuffView *)sender;
- (void)viewTouchEnd:(WTouchStuffView *)sender;

@end

@interface WTouchStuffView : UIView
{
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
    
}
@property (nonatomic,assign)id<TouchStuffViewDelegate> delegate;
//david add
- (CGAffineTransform)viewTransform;
- (void)setupOriginalTransform:(CGFloat)rotoate;
- (void)flipHorizontal;
- (void)flipVertical;
- (void)setHilight:(BOOL)flag;

@property (nonatomic, strong) UIImageView *rotateButton;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) BOOL isFlip;
@property (nonatomic, assign) CGAffineTransform touchTransform;
@property (nonatomic) BOOL panGestureDetected;
@property (nonatomic) CGPoint panBeginPoint;
@property (nonatomic, assign) BOOL isHilightStatus;
- (void)resetTransform:(CGAffineTransform)transform;


@property (nonatomic, strong) NSString *patternName;
@property (nonatomic, strong) NSString *gradientName;


@property (nonatomic, assign) BOOL hasMasked;
@property (nonatomic, assign) BOOL isEditing;


- (void)rotateButtonPanGestureDetected:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)clearMaskPath;

- (void)updateBtnOppositTransform;
- (BOOL)shouldApplyTransform:(CGAffineTransform)transform;

//5.5
- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point orientation:(NSString *)orientation;// hor ver;

- (void)storeFinalTransform:(CGAffineTransform)transform;

@property (nonatomic, assign) BOOL isAutoFlat;

@end
