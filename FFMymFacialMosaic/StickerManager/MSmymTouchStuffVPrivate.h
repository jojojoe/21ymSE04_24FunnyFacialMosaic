//
//  MSmymTouchStuffVPrivate.h
//  FFMymFacialMosaic
//
//  Created by Joe on 2021/12/24.
//


#import "MSmymTouchStuffV.h"
#import <Foundation/Foundation.h>
#import "MSmymTouchStuffV.h"
@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end

@interface WTouchStuffView (Private)
- (void)touchViewButtonOppositTransform:(UIView *)touchView;
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
- (CGAffineTransform)calculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)updateOriginalTransformForTouches:(NSSet *)touches;

- (void)cacheBeginPointForTouches:(NSSet *)touches;
- (void)removeTouchesFromCache:(NSSet *)touches;

- (BOOL)shouldApplyTransform:(CGAffineTransform)transform;

//5.5
- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)logTheTransform:(CGAffineTransform) calculatedTransform;
@end
