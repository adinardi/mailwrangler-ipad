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
}

@property (nonatomic, retain) NSManagedObject *account;

- (IBAction) hitSave:(id)selector;

@end
