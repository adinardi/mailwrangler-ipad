//
//  EditAccount.h
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootViewController;

@interface EditAccountController : UIViewController <UITextFieldDelegate> {
	NSManagedObject *account;
  bool isNewAccount;
	
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *domainField;
	
	NSFetchedResultsController *fetchedResultsController;
  RootViewController *rootViewController;
}

@property (nonatomic, retain) NSManagedObject *account;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) RootViewController *rootViewController;
@property bool isNewAccount;

- (IBAction) hitSave:(id)selector;
- (IBAction) hitCancel:(id)selector;

- (BOOL) textFieldShouldReturn:(UITextField *)textField;

@end
