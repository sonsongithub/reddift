//
//  UZTextView.m
//  Text
//
//  Created by sonson on 2013/06/13.
//  Copyright (c) 2013年 sonson. All rights reserved.
//

#import "ReddiftTextView.h"

#import <CoreText/CoreText.h>

#define TAP_MARGIN 15

@implementation ReddiftTextView

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - for UIMenuController

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストをクリップボードにコピーする．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)copy:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストでfind2chのスレッドタイトル検索を実行する．
 * 実行するとブックマークビューが開かれる．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)titleSearch:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストでスレッド内部検索を実行する．
 * 実行するとブックマークビューが開かれる．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)threadSearch:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストでGoogle検索を実行する．
 * 実行するとWebViewコントローラが開かれる．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)google:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストをNG IDに追加する．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)addNGID:(id)sender {
	[self resignFirstResponder];
//	NSString *text = [self.attributedString.string substringWithRange:self.selectedRange];
//	NSString *boardTitle = _res.thread.threadInfo.boardInfo.title;
//	[[C2CloudDataManager sharedInstance] addNGIDWithIdentifier:text
//														 board:_res.thread.threadInfo.boardInfo.board
//													boardTitle:boardTitle
//												   threadTitle:_res.thread.title
//														number:@(_res.thread.threadInfo.dat)
//													applyToAll:[[NSUserDefaults standardUserDefaults] boolForKey:C2UserDefaultsNGApplyAllThreadsKey]];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストをNGネームに追加する．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)addNGName:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * 選択されているテキストをNGワードに追加する．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)addNGWord:(id)sender {
	[self resignFirstResponder];
}

/**
 * UIMenuControllerのアクションメソッド．
 * ビューに含まれるすべてのテキストを選択状態にする．
 * @param sender メソッドの呼び出し元．おそらくUIMenuControllerオブジェクト．
 **/
- (void)selectAll:(id)sender {
	[self setSelectedRange:NSMakeRange(0, self.attributedString.length)];
}

#pragma mark - Override

- (void)prepareForInitialization {
	[super prepareForInitialization];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartSelection:) name:@"didStartSelection" object:nil];
}

- (void)didStartSelection:(NSNotification*)notification {
	if (notification.object != self) {
		[self cancelSelectedText];
	}
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(titleSearch:))
		return YES;
	if (action == @selector(google:))
		return YES;
	if (action == @selector(threadSearch:))
		return YES;
	if (action == @selector(copy:))
		return YES;
	if (action == @selector(addNGID:))
		return YES;
	if (action == @selector(addNGName:))
		return YES;
	if (action == @selector(addNGWord:))
		return YES;
	if (action == @selector(selectAll:))
		return YES;
	return NO;
}

@end
