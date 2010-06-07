    //
//  ModalBrowser.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModalBrowser.h"


@implementation ModalBrowser

@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self
											   action:@selector(dismissView:)] autorelease];
	showingActions = NO;
  NSLog(@"modal browser loaded");
}


- (void) loadURL:(NSURLRequest *)request {
NSLog(@"got url");
	[webView loadRequest:request];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[webView loadRequest:request];
		return NO;
	}
	return YES;
}

- (void) goBack:(id)selector {
	[webView goBack];
}

- (void) goForward:(id)selector {
	[webView goForward];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self updateNavButtons];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateNavButtons];
}

- (void) updateNavButtons {
	if([webView canGoBack]) {
		backBtn.enabled = YES;
	} else {
		backBtn.enabled = NO;
	}
	
	if ([webView canGoForward]) {
		forwardBtn.enabled = YES;
	} else {
		forwardBtn.enabled = NO;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dismissView:(id)sender {
	
    // Call the delegate to dismiss the modal view
    [delegate didDismissModalView];
}

- (void) doAction:(id)selector {
	if (!showingActions) {
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
	
		[sheet showFromBarButtonItem:actionBtn animated:YES];
		[sheet release];
	
		showingActions = YES;
	}
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:[[webView request] URL]];
	}
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	showingActions = NO;
}

- (void) actionSheetCancel:(UIActionSheet *)actionSheet {
	showingActions = NO;
}

- (void) doReload:(id)selector {
	[webView reload];
}

- (void)dealloc {
    [super dealloc];
}


@end
