//
//  DetailViewController.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, rootViewController, currentPassword;


#pragma mark -
#pragma mark Object insertion

- (IBAction)insertNewObject:(id)sender {
	
	[rootViewController insertNewObject:sender];	
}


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject {
    
	if (detailItem != managedObject) {
		[detailItem release];
		detailItem = [managedObject retain];
		
    [rootViewController passwordForAccount:detailItem];
    self.currentPassword = [detailItem valueForKey:@"password"];
    [detailItem setValue:@"" forKey:@"password"];
    
        // Update the view.
		if ([[detailItem valueForKey:@"username"] compare:@"username"] == NSOrderedSame) {
			return;
		}
		if ([self.currentPassword compare:@""] == NSOrderedSame) {
			return;
		}
		
        [self configureView];
	}
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
}


- (void)configureView {
    // Update the user interface for the detail item.
    // detailDescriptionLabel.text = [[detailItem valueForKey:@"timeStamp"] description];
	
	[webView setDelegate:self];
	
	NSString *domain = [detailItem valueForKey:@"domain"];
	//NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSURL *url = nil;
	if ([domain compare:@"gmail.com"] == NSOrderedSame) {
		url = [NSURL URLWithString:@"https://mail.google.com/mail/?logout"];
	} else {
		NSString *domainString = [NSString stringWithFormat:@"https://mail.google.com/a/%@/?logout", domain];
		url = [NSURL URLWithString:domainString];
	}
		 
//	NSArray *cookies = [storage cookiesForURL:url];
//	NSEnumerator *enumerator = [cookies objectEnumerator];
//	id object;
//	while (object = [enumerator nextObject]) {
//		NSLog(@"coookie %@", object);
//		[storage deleteCookie:object];
//	}
	[webView loadRequest:[NSURLRequest requestWithURL:url]];		 
}

- (void) webViewDidFinishLoad:(UIWebView *) view {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSString *username = [detailItem valueForKey:@"username"];
	NSString *password = self.currentPassword;
	// NSString *domain = [detailItem valueForKey:@"domain"];
	
	NSString *loginCode = [NSString stringWithFormat:@"\
						   document.getElementById('Email').value = '%@'; \
						   document.getElementById('Passwd').value = '%@'; \
						   document.getElementById('gaia_loginform').submit();", username, password];
	
	[webView stringByEvaluatingJavaScriptFromString: loginCode];
}

- (void) webViewDidStartLoad:(UIWebView *) view {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Accounts";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}


#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	
    [popoverController release];
    [toolbar release];
	
	[detailItem release];
	[detailDescriptionLabel release];
    
	[super dealloc];
}	


@end
