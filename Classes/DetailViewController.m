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



@implementation DetailViewController;

@synthesize toolbar,
            popoverController,
            detailItem,
            detailDescriptionLabel,
            rootViewController,
            currentPassword,
            accountsButton,
            addButton,
            navBar;


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
  // This indicates that the account we were showing was probably deleted.
  if (managedObject == nil) {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    self.navBar.topItem.title = @"";
    return;
  }  
  
	if (detailItem != managedObject || hasLoggedIn == NO) {
		[detailItem release];
		detailItem = [managedObject retain];

    [rootViewController passwordForAccount:detailItem];
    self.currentPassword = [detailItem valueForKey:@"password"];
    [detailItem setValue:@"" forKey:@"password"];
    
    hasLoggedIn = NO;
    
        // Update the view.
		if ([(NSString *)[detailItem valueForKey:@"username"] compare:@""] == NSOrderedSame) {
			return;
		}
		if ([self.currentPassword compare:@""] == NSOrderedSame) {
			return;
		}
		
    [self configureView];
    
    // NSLog(@"new account %@", [[detailItem objectID] URIRepresentation]);
    [[NSUserDefaults standardUserDefaults] setObject:[[[detailItem objectID] URIRepresentation] absoluteString] forKey:@"lastOpenAccount"];
	}
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
}


- (void)configureView {
    // Update the user interface for the detail item.
    // detailDescriptionLabel.text = [[detailItem valueForKey:@"timeStamp"] description];
	
	[webView setDelegate:self];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    NSEnumerator *enumerate = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerate nextObject]) {
        [cookieStorage deleteCookie:cookie];
    }
	
	NSString *domain = [detailItem valueForKey:@"domain"];
	//NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSURL *url = nil;
	if ([domain compare:@"gmail.com"] == NSOrderedSame) {
		url = [NSURL URLWithString:@"https://mail.google.com/"];
	} else {
		NSString *domainString = [NSString stringWithFormat:@"https://mail.google.com/a/%@", domain];
		url = [NSURL URLWithString:domainString];
	}
  
  self.navBar.topItem.title = [detailItem valueForKey:@"desc"];
		 
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
                function mailwranglerLogin() { \
                  if (document.getElementById('errormsg_0_Passwd')) { \
                    return 'FAIL'; \
                  } \
                  if (document.getElementById('errormsg_0_Email')) { \
                    return 'FAIL'; \
                  } \
                  if (document.getElementById('gaia_loginform')) { \
                    document.getElementById('Email').value = '%@'; \
                    document.getElementById('Passwd').value = '%@'; \
                    document.getElementById('gaia_loginform').submit(); \
                    return 'OK'; \
                  } \
                  try { \
                    if (document.getElementsByName('viewport')[0].content.indexOf(', width=device-width') > -1) { \
                      document.getElementsByName('viewport')[0].setAttribute('content', document.getElementsByName('viewport')[0].content.replace(', width=device-width', ', width=200')); \
                    } \
                  } catch (e) {} \
                  return 'NOTLOGINPAGE';\
                }; \
                mailwranglerLogin(); \
                  ", username, password];
	
	NSString *returnCode = [webView stringByEvaluatingJavaScriptFromString: loginCode];
  //NSLog(@"RETURN ");
  if ([returnCode compare:@"OK"] == NSOrderedSame) {
    hasLoggedIn = YES;
  } else if ([returnCode compare:@"FAIL"] == NSOrderedSame) {
    hasLoggedIn = NO;
  } else if ([returnCode compare:@"NOTLOGINPAGE"] == NSOrderedSame) {
    //if ([[[[webView request] URL] absoluteString] compare:@"about:blank"] == NSOrderedSame) {
      //NSLog(@"OMG RELOADED");
      //[webView loadHTMLString:content baseURL:fakeUrl];
      //[content release];
      //[fakeUrl release];
    //}
  } else {
    //NSLog(@"reloading view:");
    //NSURL *url = [[NSURL alloc] initWithString:[[[webView request] URL] absoluteString]];
    //[webView stopLoading];
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    //content = [returnCode retain];
    //fakeUrl = [url retain];
  }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  //NSLog(@"web view error %@", error);
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	//NSLog(@"web view should load %@, %d", request, navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		ModalBrowser *modalBrowser = [[ModalBrowser alloc] initWithNibName:@"ModalBrowser" bundle:nil];
		// modalBrowser.delegate = self;

		UINavigationController *modalNavController = [[UINavigationController alloc]
								initWithRootViewController:modalBrowser];
		[self presentModalViewController:modalNavController animated:YES];
		[modalBrowser loadURL:request];
		
		[modalBrowser autorelease];
		[modalNavController autorelease];
		
		//[modalBrowser release];
		//[modalNavController release];
	
		return NO;
	}
	
	return YES;
}

- (void)didDismissModalView {
	NSLog(@"did dismiss");
    // Dismiss the modal view controller
    // [self dismissModalViewControllerAnimated:YES];
}

- (void) webViewDidStartLoad:(UIWebView *) view {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


#pragma mark -
#pragma mark Split view support

//- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
//    
//    barButtonItem.title = @"Accounts";
//
//    NSMutableArray *items = [[toolbar items] mutableCopy];
//
//	// Remove the previous item. Apparently this gets called frequently if the 
//	// modal browser comes up and down -- and this gets inserted weirdly.
//	if (![items containsObject:barButtonItem]) {
//		[items insertObject:barButtonItem atIndex:0];
//		[toolbar setItems:items animated:YES];
//	}
//    [items release];
//    self.popoverController = pc;
//}
//
//
//// Called when the view is shown again in the split view, invalidating the button and popover controller.
//- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
//    
//    NSMutableArray *items = [[toolbar items] mutableCopy];
//    [items removeObjectAtIndex:0];
//    [toolbar setItems:items animated:YES];
//    [items release];
//
//    self.popoverController = nil;
//}


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


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.topItem.title = @"";
}

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
    // [super didReceiveMemoryWarning];
	NSLog(@"Detail view got memory warning. Ignoring.");
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	
    [popoverController release];
    [toolbar release];
	
	[detailItem release];
	[detailDescriptionLabel release];
    
	[super dealloc];
}

- (void) clickAccountsButton:(id)sender {
  if ([accountsPopover isPopoverVisible]) {
    [self hidePopover];
  } else {
    [self showAccountsPopover];
  }
}

- (void) showAccountsPopover {
  if (!accountsPopover) {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    accountsPopover = [[UIPopoverController alloc] initWithContentViewController:nav];
    [nav release];
  }
  
  [accountsPopover setPopoverContentSize:CGSizeMake(320.0, 1100.0)];
  [accountsPopover presentPopoverFromBarButtonItem:accountsButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) hidePopover {
  [accountsPopover dismissPopoverAnimated:YES];
}

@end
