    //
//  ModalBrowser.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModalBrowser.h"


@implementation ModalBrowser

@synthesize delegate, backBtn, forwardBtn, actionBtn, webView;

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
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self
											   action:@selector(dismissView:)] autorelease];
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backBtn" ofType:@"png"]] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
	back.enabled = NO;
	
	UIBarButtonItem *filler1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[filler1 setWidth:20.0f];
	
	UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"forwardBtn" ofType:@"png"]] style:UIBarButtonItemStylePlain target:self action:@selector(goForward:)];
	forward.enabled = NO;
	
	UIBarButtonItem *filler2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[filler2 setWidth:20.0f];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(doReload:)];
	
	UIBarButtonItem *filler3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[filler3 setWidth:20.0f];
	
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doAction:)];
	
	UIToolbar *bar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,0.0f,180.0f,44.0f)] autorelease];
	[bar setItems:[NSArray arrayWithObjects:back, filler1, forward, filler2, refresh, filler3, action, nil]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:bar] autorelease];

	self.backBtn = back;
	self.forwardBtn = forward;
	self.actionBtn = action;
	[back release];
	[forward release];
	[refresh release];
	[action release];
	[filler1 release];
	[filler2 release];
	[filler3 release];
	showingActions = NO;
}


- (void) loadURL:(NSURLRequest *)request {
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
  
  // Set the title of the nav bar in the modal view to the title of the page we've loaded.
  self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
  
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
	// NSLog(@"Modal browser got memory warning. Release.");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	// NSLog(@"view unloading");
	// self.webView = nil;
	self.backBtn = nil;
	self.forwardBtn = nil;
	self.actionBtn = nil;
	self.webView = nil;
	
	[super viewDidUnload];
}

- (void)dismissView:(id)sender {
	
    // Call the delegate to dismiss the modal view
    // [delegate didDismissModalView];
	[self dismissModalViewControllerAnimated:YES];
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
	// NSLog(@"deallocing modal browser");
	self.backBtn = nil;
	self.forwardBtn = nil;
	self.actionBtn = nil;
	self.webView = nil;
    [super dealloc];
}


@end
