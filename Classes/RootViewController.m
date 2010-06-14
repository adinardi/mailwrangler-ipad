//
//  RootViewController.m
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"

/*
 This template does not ensure user interface consistency during editing operations in the table view. You must implement appropriate methods to provide the user experience you require.
 */

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation RootViewController

@synthesize detailViewController, fetchedResultsController, managedObjectContext;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self doneEditing];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.    
    return YES;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[managedObject valueForKey:@"desc"] description];
}


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject:(id)sender {
    
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }    
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:@"" forKey:@"desc"];
    [newManagedObject setValue:@"" forKey:@"username"];
    [newManagedObject setValue:@"" forKey:@"password"];
    [newManagedObject setValue:@"gmail.com" forKey:@"domain"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:newManagedObject];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    detailViewController.detailItem = newManagedObject;
	
  [self showEditAccount:newManagedObject isNewAccount:YES];
}

- (void) passwordForAccount:(NSManagedObject *)account {
  NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
  OSStatus keychainErr = noErr;
  
  [passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];

  NSMutableString *username = [NSMutableString stringWithString:[account valueForKey:@"username"]];
  [username appendString:@"@"];
  [username appendString:[account valueForKey:@"domain"]];

  NSData *keychainItemID = [NSData dataWithBytes:[username UTF8String]
                            length:strlen([username UTF8String])];

  // [passwordQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
  [passwordQuery setObject:username forKey:(id)kSecAttrAccount];
  [passwordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
  // [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
  [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
  
  // NSMutableDictionary *outDictionary = nil;
  NSData *passwordData = nil;
  keychainErr = SecItemCopyMatching((CFDictionaryRef)passwordQuery, (CFTypeRef *)&passwordData);
  
  NSString *password;
  if (keychainErr == noErr) {
      // Convert the data dictionary into the format used by the view controller:
      password = [[[NSString alloc] initWithBytes:[passwordData bytes]
             length:[passwordData length] encoding:NSUTF8StringEncoding] autorelease];
  } else if (keychainErr == errSecItemNotFound) {
      // Put default values into the keychain if no matching
      // keychain item is found:
      // [self resetKeychainItem];
      password = [[[NSString alloc] init] autorelease];
  } else {
      // Any other error is unexpected.
      NSAssert(NO, @"Serious error.\n");
  }
  
  [account setValue:password forKey:@"password"];
  [passwordData release];
  [passwordQuery release];
}

- (void) storePasswordForAccount:(NSManagedObject *)account {
  NSMutableDictionary *passwordQuery = [[NSMutableDictionary alloc] init];
  // OSStatus keychainErr = noErr;
  
  [passwordQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
  
  NSMutableString *username = [NSMutableString stringWithString:[account valueForKey:@"username"]];
  [username appendString:@"@"];
  [username appendString:[account valueForKey:@"domain"]];

  // NSLog(@"Working with ID: %@", username);
  NSData *keychainItemID = [NSData dataWithBytes:[username UTF8String]
                            length:strlen([username UTF8String])];
  
  // [passwordQuery setObject:keychainItemID forKey:(id)kSecAttrGeneric];
  [passwordQuery setObject:username forKey:(id)kSecAttrAccount];
  [passwordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
  [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
  // [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
  
  NSDictionary *passwordData = nil;
  NSMutableDictionary *newPasswordData = nil;
  
  if (SecItemCopyMatching((CFDictionaryRef)passwordQuery, (CFTypeRef *)&passwordData) == noErr) {
    newPasswordData = [NSMutableDictionary dictionaryWithDictionary:passwordData];
    [newPasswordData setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    // [newPasswordData setObject:[[account valueForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    NSMutableDictionary *keychainData = [NSMutableDictionary dictionary];
    [keychainData setObject:[[account valueForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)newPasswordData,
                (CFDictionaryRef)keychainData);
    if (status != noErr) {
      NSLog(@"Couldn't update the Keychain Item. %d", status);
    }
  } else {
    newPasswordData = [NSMutableDictionary dictionary];
    
    //[newPasswordData setObject:keychainItemID forKey:(id)kSecAttrGeneric];
    [newPasswordData setObject:username forKey:(id)kSecAttrAccount];
    [newPasswordData setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
 
    //NSMutableDictionary *keychainData = [NSMutableDictionary dictionary];
    [newPasswordData setObject:[[account valueForKey:@"password"] dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)newPasswordData, NULL);
    
    if (status != noErr) {
      NSLog(@"Couldn't add the Keychain Item. %d", status);
    } else {
      //[self storePasswordForAccount:account];
      //NSLog(@"Stored data %d", status);
    }
  }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObject *objectToDelete = [fetchedResultsController objectAtIndexPath:indexPath];
        if (detailViewController.detailItem == objectToDelete) {
            detailViewController.detailItem = nil;
        }
        
        [self removeAccount:objectToDelete];
    }   
}

- (void) removeAccount:(NSManagedObject *) object {
  NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
  [context deleteObject:object];
  NSError *error;
  if (![context save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
  }
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return YES;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set the detail item in the detail view controller.
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    detailViewController.detailItem = selectedObject;
    [detailViewController hidePopover];
}

- (void)tableView:(UITableView *)aTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];

	[self showEditAccount:selectedObject isNewAccount:NO];
}

- (void) showEditAccount:(NSManagedObject *) selectedObject isNewAccount:(bool)isNewAccount {
	EditAccountController *acct = [[[EditAccountController alloc] initWithNibName:@"EditAccountController" bundle:nil] retain];
  
  acct.isNewAccount = isNewAccount;
  acct.rootViewController = self;
	acct.account = selectedObject;
	//NSLog(@"frc %@", [self fetchedResultsController]);
	//[acct setFetchedResultsController:[self fetchedResultsController]];
  
  // Make sure the account view is the right size to fill the space.
  acct.view.frame = self.view.frame;
	[self.view addSubview:acct.view];
  
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:acct
											   action:@selector(hitSave:)] autorelease];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                        target:acct
                        action:@selector(hitCancel:)] autorelease];
  if (isNewAccount) {
    self.navigationItem.title = @"Add Account";
  } else {
    self.navigationItem.title = @"Edit Account";
  }
  
	//[self presentModalViewController:acct animated:YES];
	[acct release];
}

- (void) doneEditing {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
											   target:self
											   action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Accounts";
	
	// I would rather just update the cell with an issue, but hey.
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"desc" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}    


#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    
    [detailViewController release];
    [fetchedResultsController release];
    [managedObjectContext release];
    
    [super dealloc];
}

@end
