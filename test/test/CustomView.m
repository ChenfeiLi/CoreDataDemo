//
//  CustomView.m
//  test
//
//  Created by Phoebe Li on 5/17/15.
//  Copyright (c) 2015 Mellmo. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor * greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) whiteColor.CGColor, (__bridge id) whiteColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, self.bounds);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    
    int sides = 3;
    double size = 20;
    CGPoint center = CGPointMake(self.bounds.size.width - size, self.bounds.size.height/2);
    
    double radius = size / 2.0;
    double theta = 2.0 * M_PI / sides;

    NSLog(@"color %d",self.color);
    if (self.color){
        CGContextSetStrokeColorWithColor(context, greenColor.CGColor);
        CGContextSetFillColorWithColor(context, greenColor.CGColor);
        CGContextMoveToPoint(context, center.x, center.y-radius);
        for (NSUInteger k=1; k<sides; k++) {
            float x = radius * sin(k * theta);
            float y = radius * cos(k * theta);
            CGContextAddLineToPoint(context, center.x+x, center.y-y);
        }
    }else{
        CGContextSetStrokeColorWithColor(context, redColor.CGColor);
        CGContextSetFillColorWithColor(context, redColor.CGColor);
        CGContextMoveToPoint(context, center.x, center.y+radius);
        for (NSUInteger k=1; k<sides; k++) {
            float x = radius * sin(k * theta);
            float y = radius * cos(k * theta);
            CGContextAddLineToPoint(context, center.x+x, center.y+y);
        }
    }

    CGContextFillPath(context);
    CGContextStrokePath(context);

}


@end
