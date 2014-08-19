//
//  BNRHypnosisView.m
//  HypnoBro
//
//  Created by Archer on 5/22/14.
//  Copyright (c) 2014 Oodalalee. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView ()

@property (strong, nonatomic) UIColor *circleColor;

@end

@implementation BNRHypnosisView

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    //Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y = bounds.size.height / 2.0;
    
    //The largest circle will curcumscribe the view
    float maxRadius = hypotf(bounds.size.width, bounds.size.height) / 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -=20) {
        
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI * 20.0 clockwise:YES];
    }
    
    //Configure the line width to 10 points
    path.lineWidth = 10;
    
    //Configure the drawing color to light gray
    [self.circleColor setStroke];
    
    //Draw the line
    [path stroke];
    
    //Gold challenge
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //important to place the save in front of the part which contains clipping path
    CGContextSaveGState(currentContext);
    
    //Drawing Triangle
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    CGPoint triangleOne = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect) + 100);
    CGPoint triangleTwo = CGPointMake(CGRectGetMaxX(rect) - 50, CGRectGetMaxY(rect) - 100);
    CGPoint triangleThree = CGPointMake(CGRectGetMinX(rect) + 50, CGRectGetMinY(rect) - 100);
    [trianglePath moveToPoint:triangleOne];
    [trianglePath addLineToPoint:triangleTwo];
    [trianglePath addLineToPoint:triangleThree];
    //add clipping mask
    [trianglePath addClip];
    
    //Gradient
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 2.0, 0.0, 4.0, 5.0,
        1.0, 1.0, 0.0, 1.0 };
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    CGPoint startpoint = CGPointMake(0, 0);
    CGPoint endpoint = CGPointMake(bounds.size.width, bounds.size.height);
    CGContextDrawLinearGradient(currentContext, gradient, startpoint, endpoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    //Important to place the restore in front of the logo code
    //otherwise it will be clipped as well
    CGContextRestoreGState(currentContext);
    
    
    //Bronze challenge
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    //center the logo
    float rightX = bounds.size.width / 2 - (logo.size.width / 4);
    float rightY = bounds.size.height / 2 - (logo.size.height / 4);
    CGRect logoRect = CGRectMake(rightX, rightY, logo.size.width / 2, logo.size.height / 2);
    CGContextSetShadow(currentContext, CGSizeMake(4, 10), 3);
    [logo drawInRect:logoRect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //All BNRHypnosisViews start with a clear background color
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

//When a finger touches the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    //Get 3 random numbers between 0 and 1
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.circleColor = randomColor;
}

//We are implementing a custom accessor for circleColor property to send
//setNeedsDisplay to the view whenever this property is changed
//Have to send ourself because custom subclass.
- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

@end
