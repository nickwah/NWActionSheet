//
//  NWActionSheet.h
//  gossip
//
//  Created by Nicholas White on 1/18/16.
//  Copyright © 2016 Nicholas White. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NWActionSheetCallback)();
typedef enum : NSUInteger {
    NWActionSheetStyleNormal,
    NWActionSheetStyleCancel,
    NWActionSheetStyleDestroy,
} NWActionSheetStyle;

@interface NWActionSheet : UIView

@property (nonatomic, readonly) NSArray *buttons;

- (void)addButtonWithTitle:(NSString*)title actionBlock:(NWActionSheetCallback)callback;
- (void)addButtonWithTitle:(NSString*)title style:(NWActionSheetStyle)style actionBlock:(NWActionSheetCallback)callback;
- (void)addButtonWithView:(UIView*)view actionBlock:(NWActionSheetCallback)callback;

- (void)show;
- (void)showInView:(UIView*)view;
- (void)dismiss;

@end
