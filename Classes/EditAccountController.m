    //
//  EditAccount.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditAccountController.h"


@implementation EditAccountController

@synthesize rootViewController, isNewAccount, account;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (UITextField *) getBaseTextFieldWithPlaceholderText: (NSString *)text {
	UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(120.0f, 12.0f, 192.0f, 22.0f)];
	field.clearButtonMode = UITextFieldViewModeWhileEditing;
	field.autocorrectionType = UITextAutocorrectionTypeNo;
	field.autocapitalizationType = UITextAutocapitalizationTypeNone;
	field.returnKeyType = UIReturnKeyNext;
	field.textAlignment = UITextAlignmentLeft;
	field.delegate = self;
	field.textColor = [UIColor colorWithRed:0.22 green:0.459 blue:0.843 alpha:1.0];
	
	field.placeholder = text;
	
	return field;
}

- (UITableViewCell *) getBaseCellWithText: (NSString *)text {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"account"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = text;
	
	return cell;
}

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	UITableViewCell *userCell = [self getBaseCellWithText:@"Username"];
	usernameField = [self getBaseTextFieldWithPlaceholderText:@"myname"];
	[userCell addSubview:usernameField];
	
	UITableViewCell *passwordCell = [self getBaseCellWithText:@"Password"];
	passwordField = [self getBaseTextFieldWithPlaceholderText:@"xyz123"];
	passwordField.secureTextEntry = YES;
	[passwordCell addSubview:passwordField];
	
	UITableViewCell *descriptionCell = [self getBaseCellWithText:@"Description"];
	descriptionField = [self getBaseTextFieldWithPlaceholderText:@"Work"];
	[descriptionCell addSubview:descriptionField];
	
	UITableViewCell *domainCell = [self getBaseCellWithText:@"Domain"];
	domainField = [self getBaseTextFieldWithPlaceholderText:@"gmail.com"];
	domainField.text = @"gmail.com";
	domainField.returnKeyType = UIReturnKeyDone;
	[domainCell addSubview:domainField];
	
	cells = [[NSArray alloc] initWithObjects:descriptionCell, userCell, passwordCell, domainCell, nil];
	
	return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [cells objectAtIndex:indexPath.row];
}

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
	//NSLog(@"Edit account got memory warning. Release.");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[account release];
	[fetchedResultsController release];
    [super dealloc];
}

//- (void) setAccount:(NSManagedObject *)managedObject {
//	[account release];
//	account = [managedObject retain];
//}

- (void) hitSave:(id)selector {
  if ([descriptionField.text compare:@""] == NSOrderedSame ||
      [usernameField.text compare:@""] == NSOrderedSame ||
      [passwordField.text compare:@""] == NSOrderedSame ||
      [domainField.text compare:@""] == NSOrderedSame) {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Incomplete Account Information" message:@"Please complete all fields to save this account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
    return;
  }

  [account setValue:descriptionField.text forKey:@"desc"];
	[account setValue:usernameField.text forKey:@"username"];
	[account setValue:passwordField.text forKey:@"password"];
	[account setValue:domainField.text forKey:@"domain"];

  [rootViewController storePasswordForAccount:account];
  [account setValue:@"" forKey:@"password"];
	[self.view removeFromSuperview];
  [self.rootViewController doneEditing];
}

- (void) hitCancel:(id)selector {
	//NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	//[context deleteObject:account];
  if (isNewAccount) {
    [self.rootViewController removeAccount:account];
  }
  [self.view removeFromSuperview];
  [self.rootViewController doneEditing];
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
