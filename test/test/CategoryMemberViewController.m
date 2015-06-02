//
//  MasterViewController.m
//  test
//
//  Created by Brett Callaghan on 5/9/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import "CategoryMemberViewController.h"
#import "TestUtils.h"
#import "CategoryMember.h"
#import "CustomView.h"


@interface CategoryMemberViewController ()
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


#pragma mark -
@implementation CategoryMemberViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObject = _managedObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    return self;
}
							
- (void)dealloc
{
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.title = @"Category";
    
    //ToolBar
    
    #define SCREEN_FRAME [[UIScreen mainScreen] applicationFrame]
    
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 44);
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:frame];
    toolBar.frame = CGRectMake(0,self.view.frame.size.height-toolBar.frame.size.height,SCREEN_FRAME.size.width,toolBar.frame.size.height);
    
    //Segment Control Bar
    NSArray *segItemsArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"up.png"], [UIImage imageNamed:@"down.png"], @"ALL", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segItemsArray];
    segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = 2;
    UIBarButtonItem *segmentedControlButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)segmentedControl];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *barArray = [NSArray arrayWithObjects: flexibleSpace, segmentedControlButtonItem, flexibleSpace, nil];
    [segmentedControl addTarget:self action:@selector(segmentSwitch:) forControlEvents:UIControlEventValueChanged];
    [self setToolbarItems:barArray];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)segmentSwitch:(id)sender{
    UISegmentedControl *segment=(UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            NSLog(@"up");
            NSError *error = nil;

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryMember" inManagedObjectContext:_managedObjectContext]; // specify your entity (table)
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value > previousValue"]; // specify your condition (predicate)
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchBatchSize:20];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
            
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            [self.fetchedResultsController initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            
            if (![self.fetchedResultsController performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }

            NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error]; // execute

            [self.tableView reloadData];
            break;
        }
        case 1:
        {
            NSLog(@"down");

            NSError *error = nil;

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryMember" inManagedObjectContext:_managedObjectContext]; // specify your entity (table)
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value <= previousValue"]; // specify your condition (predicate)
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchBatchSize:20];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
            
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            [self.fetchedResultsController initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
            
            if (![self.fetchedResultsController performFetch:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error]; // execute
            
            [self.tableView reloadData];
            break;
        }
        case 2:
        {
            NSLog(@"All");
            _fetchedResultsController=nil;
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation);
}

// TODO: Implement the refresh action.
- (IBAction)refresh:(id)sender
{
    /*
     The following method generates an updated json file containing updated values for the category displayed by this view controller.
     The categories.json file is located in this application's document's directory.
     1) Import the contents of this file (NSJSONSerialization).
     2) Parse the json data and update the "value" property of the CategoryMember Core Data entities.
     3) Set the CategoryMember object's "previousValue" (See README) to its previous value.
     4) Don't add duplicates.
     5) You will need to add NSManagedObject instances to the view controller's managedObjectContext.
     */
    [TestUtils refreshCategoriesJSONFile];
    //[self refreshCategoriesJSONFile];
    
    NSError *error = nil;
//    if (![_managedObjectContext save:&error]) {
//        NSLog(@"darn... %@", error);
//        exit(1);
//    }
    
    NSError* err = nil;
    //read the file from document folder
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:(0)];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"categories.json"];
    NSArray* categories = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    
    //get all the data from coreData
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryMember" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        NSLog(@"jason value: %@", [obj objectForKey:@"name"]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [obj objectForKey:@"name"]];
        NSArray *results = [fetchedObjects filteredArrayUsingPredicate:predicate];
        if (results.count == 0) {
                CategoryMember *categoryMember = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryMember" inManagedObjectContext:_managedObjectContext];
                categoryMember.previousValue = 0;
                categoryMember.name = [obj objectForKey:@"name"];
                categoryMember.value = [obj objectForKey:@"value"];
        }else{
            for (CategoryMember *info in results) {
                [info setValue:info.value forKey:@"previousValue"];
                [info setValue:[obj objectForKey:@"value"] forKey:@"value"];
                [self.tableView reloadData];
                NSLog(@"Name: %@", info.name);
                NSLog(@"value: %@", info.value);                
            }
        }

        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"darn... %@", [error localizedDescription]);
        }
    }];

    
    //[[NSException exceptionWithName:NSGenericException reason:@"The -refresh method must be implemented." userInfo:nil] raise];
}


#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryMember" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
		default:
			break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //caculate the difference value
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [f setPositivePrefix:[f plusSign]];
    [f setNegativePrefix:[f minusSign]];
    NSNumber *value = [object primitiveValueForKey:@"value"];
    NSNumber *previous = [object primitiveValueForKey:@"previousValue"];
    int diff = [value intValue] - [previous intValue];
    NSString *formattedDiff = [f stringFromNumber:[NSNumber numberWithInteger:diff]];
     NSLog(@"diff%d",diff);
    cell.textLabel.text = formattedDiff;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [object primitiveValueForKey:@""];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    cell.detailTextLabel.text = [numberFormatter stringFromNumber:[object primitiveValueForKey:@"name"]];

    if (diff > 0) {
        if (![cell.backgroundView isKindOfClass:[CustomView class]]) {
            CustomView *greenView = [[CustomView alloc] init];
            greenView.color = YES;
            cell.backgroundView = greenView;
        }
        
    }else {
        ((CustomView *) cell.backgroundView).color = 0;
        if (![cell.backgroundView isKindOfClass:[CustomView class]]) {
            CustomView *redView = [[CustomView alloc] init];
            redView.color = NO;
            cell.backgroundView = redView;
        }
    }
    cell.detailTextLabel.hidden = NO;
}

//- (void) refreshCategoriesJSONFile
//{
//    NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
//    [json setObject:@"value1" forKey:@"name"];
//    [json setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    
//    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
//    jsonArray[0] = json;
//    
//    NSMutableDictionary *json2= [[NSMutableDictionary alloc] init];
//    [json2 setObject:@"value2" forKey:@"name"];
//    [json2 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[1] = json2;
//    
//    NSMutableDictionary *json3= [[NSMutableDictionary alloc] init];
//    [json3 setObject:@"value3" forKey:@"name"];
//    [json3 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[2] = json3;
//    
//    NSMutableDictionary *json4= [[NSMutableDictionary alloc] init];
//    [json4 setObject:@"value4" forKey:@"name"];
//    [json4 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[3] = json4;
//    
//    NSMutableDictionary *json5= [[NSMutableDictionary alloc] init];
//    [json5 setObject:@"value5" forKey:@"name"];
//    [json5 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[4] = json5;
//    
//    NSMutableDictionary *json6= [[NSMutableDictionary alloc] init];
//    [json6 setObject:@"value6" forKey:@"name"];
//    [json6 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[5] = json6;
//    
//    NSMutableDictionary *json7= [[NSMutableDictionary alloc] init];
//    [json7 setObject:@"value7" forKey:@"name"];
//    [json7 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[6] = json7;
//    
//    NSMutableDictionary *json8= [[NSMutableDictionary alloc] init];
//    [json8 setObject:@"value8" forKey:@"name"];
//    [json8 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[7] = json8;
//    
//    NSMutableDictionary *json9= [[NSMutableDictionary alloc] init];
//    [json9 setObject:@"value9" forKey:@"name"];
//    [json9 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[8] = json9;
//    
//    NSMutableDictionary *json10= [[NSMutableDictionary alloc] init];
//    [json10 setObject:@"value10" forKey:@"name"];
//    [json10 setObject:[NSNumber numberWithUnsignedLongLong:random()%1000] forKey:@"value"];
//    jsonArray[9] = json10;
//    
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            
//            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [path objectAtIndex:(0)];
//            NSLog(@"document Directory:\n%@",documentsDirectory);
//            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"categories.json"];
//
//            NSData *json = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:nil];
//            BOOL success = [json writeToFile:dataPath atomically:YES];
//            NSAssert(success, @"writeToFile failed");
//    });
//}


@end
