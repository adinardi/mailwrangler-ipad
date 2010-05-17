    //
//  EditAccount.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditAccountController.h"


@implementation EditAccountController

@synthesize rootViewController, isNewAccount;

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
	// NSLog(@"editing %@", [account valueForKey:@"username"]);
	[usernameField setText:[account valueForKey:@"username"]];
  [descriptionField setText:[account valueForKey:@"desc"]];

  [rootViewController passwordForAccount:account];
	[passwordField setText:[account valueForKey:@"password"]];
  [account setValue:@"" forKey:@"password"];

	[domainField setText:[account valueForKey:@"domain"]];
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


- (void)dealloc {
    [super dealloc];
}

- (void) setAccount:(NSManagedObject *)managedObject {
	[account release];
	account = [managedObject retain];
}

- (void) hitSave:(id)selector {
  [account setValue:descriptionField.text forKey:@"desc"];
	[account setValue:usernameField.text forKey:@"username"];
	[account setValue:passwordField.text forKey:@"password"];
	[account setValue:domainField.text forKey:@"domain"];

  [rootViewController storePasswordForAccount:account];
  [account setValue:@"" forKey:@"password"];
	[self.view removeFromSuperview];
}

- (void) hitCancel:(id)selector {
	//NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	//[context deleteObject:account];
  if (isNewAccount) {
    [self.rootViewController removeAccount:account];
  }
  [self.view removeFromSuperview];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
  if (textField == descriptionField) {
    [usernameField becomeFirstResponder];
  } else if (textField == usernameField) {
    [passwordField becomeFirstResponder];
  } else if (textField == passwordField) {
    [domainField becomeFirstResponder];
  } else if (textField == domainField) {
    [self hitSave:textField];
  }
  return NO;
}


@end
