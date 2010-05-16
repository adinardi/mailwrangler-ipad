//
//  RootViewController.h
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Security/Security.h>
#import "EditAccountController.h"


@class DetailViewController;


@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    DetailViewController *detailViewController;
	EditAccountController *editAccount;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
	UIView *editView;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet EditAccountController *editAccount;
@property (nonatomic, retain) IBOutlet UIView *editView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(id)sender;
- (void) showEditAccount:(NSManagedObject *)selectedObject;
- (void) passwordForAccount:(NSManagedObject *)account;
- (void) storePasswordForAccount:(NSManagedObject *)account;

@end
