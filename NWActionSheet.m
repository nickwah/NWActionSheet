//
//  NWActionSheet.m
//  gossip
//
//  Created by Nicholas White on 1/18/16.
//  Copyright © 2016 Nicholas White. All rights reserved.
//

#import "NWActionSheet.h"

@implementation NWActionSheet {
    NSMutableArray *_buttons;
    NSMutableArray *_callbacks;
    UIView *_container;
    CGPoint _startPoint;
}

#define SheetPadding 10

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _buttons = [NSMutableArray array];
        _callbacks = [NSMutableArray array];
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title actionBlock:(NWActionSheetCallback)callback {
    [self addButtonWithTitle:title style:NWActionSheetStyleNormal actionBlock:callback];
}

- (void)addButtonWithTitle:(NSString *)title style:(NWActionSheetStyle)style actionBlock:(NWActionSheetCallback)callback {
    UILabel *view = [[UILabel alloc] init];
    view.text = title;
    view.font = style == NWActionSheetStyleNormal ? [UIFont systemFontOfSize:18] : [UIFont boldSystemFontOfSize:18];
    view.textColor = style == NWActionSheetStyleDestroy ? [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1] : [UIColor colorWithRed:0 green:0.6 blue:1.0 alpha:1];
    view.textAlignment = NSTextAlignmentCenter;
    [self addButtonWithView:view actionBlock:callback ?: ^{
    }];
}

- (void)addButtonWithView:(UIView *)view actionBlock:(NWActionSheetCallback)callback {
    if (callback) {
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButton:)];
        [view addGestureRecognizer:tap];
        view.tag = _callbacks.count;
        [_callbacks addObject:callback];
    }
    [_buttons addObject:view];
}

- (NSArray *)buttons {
    return _buttons;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _startPoint = [touches.anyObject locationInView:self];
    UIView *button = [self hitTest:_startPoint withEvent:event];
    for (UIView *view in _buttons) {
        if (view == button && view.gestureRecognizers.count) {
            view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [touches.anyObject locationInView:self];
    CGFloat xDist = loc.x - _startPoint.x;
    CGFloat yDist = loc.y - _startPoint.y;
    if (xDist * xDist + yDist * yDist > 256) { // If we've moved over 16 pixels...
        [self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIView *view in _buttons) {
        view.backgroundColor = [UIColor clearColor];
    }
}

- (void)tapButton:(UIGestureRecognizer*)tap {
    if (tap.view.tag >= _callbacks.count) return; // uh oh
    NWActionSheetCallback callback = _callbacks[tap.view.tag];
    callback();
    [self dismiss];
}

- (void)dismiss {
    [_callbacks removeAllObjects]; // So no more taps occur, and also might be good for reference counting
    [UIView animateWithDuration:0.23 animations:^{
        CGRect containerFrame = _container.frame;
        containerFrame.origin.y = self.frame.size.height;
        _container.frame = containerFrame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)render {
    CGRect frame = self.frame;
    CGFloat y = frame.size.height;
    CGFloat buttonHeight = 55;
    CGFloat containerHeight = _buttons.count * buttonHeight;
    CGFloat containerWidth = frame.size.width - SheetPadding * 2;
    CGRect containerFrame = CGRectMake(SheetPadding, frame.size.height, containerWidth, containerHeight);
    _container = [[UIView alloc] initWithFrame:containerFrame];
    _container.layer.cornerRadius = 15;
    _container.layer.masksToBounds = YES;
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    y = 0;
    for (int i = 0; i < _buttons.count; i++) {
        UIView *view = _buttons[i];
        CGRect viewFrame = view.frame;
        if (!viewFrame.size.height) {
            view.frame = CGRectMake(0, y, containerWidth, buttonHeight);
        } else {
            viewFrame.origin.y = y;
        }
        [_container addSubview:view];
        y += view.frame.size.height;
        if (i < _buttons.count - 1) {
            UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, y, containerWidth, 1)];
            spacer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
            [_container addSubview:spacer];
            y += 1;
        }
    }
    containerFrame.size.height = y;
    _container.frame = containerFrame;
}

- (void)showInView:(UIView*)view {
    [view addSubview:self];
    CGRect frame = view.frame;
    self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    //NSLog(@"Setting frame to: %@", NSStringFromCGRect(self.frame));
    if (!_container) [self render];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
    [UIView animateWithDuration:0.23 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        CGRect containerFrame = _container.frame;
        containerFrame.origin.y = self.frame.size.height - containerFrame.size.height - SheetPadding;
        _container.frame = containerFrame;
    }];
}

- (void)show {
    [self showInView:[self topmostWindow]];
}

- (UIWindow *)topmostWindow
{
    UIWindow *topWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        return win1.windowLevel - win2.windowLevel;
    }] lastObject];
    return topWindow;
}


@end
