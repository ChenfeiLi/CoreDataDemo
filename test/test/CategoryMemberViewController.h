//
//  MasterViewController.h
//  test
//
//  Created by Brett Callaghan on 5/9/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface CategoryMemberViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

- (IBAction)refresh:(id)sender;

@end
