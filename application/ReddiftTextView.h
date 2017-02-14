//
//  UZTextView.h
//  Text
//
//  Created by sonson on 2013/06/13.
//  Copyright (c) 2013年 sonson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UZTextView/UZTextView.h>

@class ReddiftTextView;

@protocol ReddiftTextViewDelegate <UZTextViewDelegate>
@end

@interface ReddiftTextView : UZTextView {
	BOOL _isPushedUIMenuController;
}
@property (nonatomic, assign) id <ReddiftTextViewDelegate> UZDelegate;
@end
