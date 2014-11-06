
#import "MBCoreDataTableViewController.h"
#import "MBCoreDataFetchControllerHelper.h"

@interface MBCoreDataTableViewController ()
@property (nonatomic, strong) MBCoreDataFetchControllerHelper *fetchControllerHelper;
@end

@implementation MBCoreDataTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

// Lazy getter
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSAssert(self.fetchRequest != nil, @"🙉 You need to pass the request!");
    NSAssert(self.managedObjectContext != nil, @"🙈 Pass in a context!!");
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil           // We  are not grouping here.
                                                   cacheName:@"Master"];  // Important for performance.
    _fetchedResultsController.delegate = self.fetchControllerHelper;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.fetchControllerHelper =
    [[MBCoreDataFetchControllerHelper alloc] initWithTableView:self.tableView
                                         usingUpdateCellsBlock:^(NSIndexPath *indexPath)
    {
        [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
                atIndexPath:indexPath];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions
- (void)deleteAllItemsInTableView
{
//    [Counter deleteAllInContext:self.managedObjectContext];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if ([self isLastIndexPath:indexPath]) {
        // Es la ultima celda, la de borrar.
        cell = [tableView dequeueReusableCellWithIdentifier:@"DeleteAllCell" forIndexPath:indexPath];
        [self configureDeleteCell:cell atIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark Datasource helpers
- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][indexPath.section];
    if (indexPath.row == [sectionInfo numberOfObjects]) {
        result = YES;
    }
    return result;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)configureDeleteCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *v in cell.contentView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *b = (UIButton *)v;
            [b addTarget:self
                  action:@selector(deleteAllItemsInTableView)
        forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#define HEIGHT_DELETE_ROW 45.0

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isLastIndexPath:indexPath]) {
        return HEIGHT_DELETE_ROW;
    }
    NSAssert(self.defaultCellHeight != 0, @"🙉 Pass in a height for row");
    
    return self.defaultCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isLastIndexPath:indexPath]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
