
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MBCoreDataTableViewController : UITableViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic) CGFloat defaultCellHeight;

- (BOOL)isLastIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAllItemsInTableView;
@end
