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

@interface ModalBrowser : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	id<ModalViewControllerDelegate> delegate;
}

- (void) loadURL:(NSURLRequest *) request;

@property (nonatomic, assign) id<ModalViewControllerDelegate> delegate;
@property (nonatomic, assign) UIWebView *webView;


@end
