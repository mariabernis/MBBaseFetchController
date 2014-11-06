
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UITableView;
@interface MBCoreDataFetchControllerHelper : NSObject<NSFetchedResultsControllerDelegate>

/* Designated initializer */
- (instancetype)initWithTableView:(UITableView *)aTableView
            usingUpdateCellsBlock:(void(^)(NSIndexPath *indexPath))blockForUpdatingCells;
@end
