//
//  ModalBrowser.h
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModalViewControllerDelegate <NSObject>

- (void)didDismissModalView;

@end

@interface ModalBrowser : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	IBOutlet UIWebView *webView;
	id<ModalViewControllerDelegate> delegate;
	
	UIBarButtonItem *backBtn;
	UIBarButtonItem *forwardBtn;
	UIBarButtonItem *actionBtn;
	
	BOOL showingActions;
}

- (void) updateNavButtons;
- (void) loadURL:(NSURLRequest *) request;

- (IBAction) goBack:(id)selector;
- (IBAction) goForward:(id)selector;
- (IBAction) doAction:(id)selector;
- (IBAction) doReload:(id)selector;

@property (nonatomic, assign) id<ModalViewControllerDelegate> delegate;
@property (nonatomic, assign) UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *backBtn;
@property (nonatomic, retain) UIBarButtonItem *forwardBtn;
@property (nonatomic, retain) UIBarButtonItem *actionBtn;


@end
