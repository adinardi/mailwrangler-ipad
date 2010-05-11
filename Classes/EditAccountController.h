//
//  EditAccount.h
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface EditAccountController : UIViewController {
	NSManagedObject *account;
	
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UITextField *domainField;
	
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSManagedObject *account;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction) hitSave:(id)selector;
- (IBAction) hitCancel:(id)selector;

@end
