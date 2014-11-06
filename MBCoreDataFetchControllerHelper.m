
#import "MBCoreDataFetchControllerHelper.h"
#import <UIKit/UIKit.h>

@interface MBCoreDataFetchControllerHelper ()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) void (^blockToExecuteWhenYouNeedToUpdateYourCell)(NSIndexPath *indexPath);
@end

@implementation MBCoreDataFetchControllerHelper

/* Designated initializer */
- (instancetype)initWithTableView:(UITableView *)aTableView
            usingUpdateCellsBlock:(void(^)(NSIndexPath *indexPath))blockForUpdatingCells
{
    self = [super init];
    if (self) {
        _tableView = aTableView;
        _blockToExecuteWhenYouNeedToUpdateYourCell = blockForUpdatingCells;
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"USE DESIGNATED INITIALIZER");
    return nil;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableV = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableV insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            self.blockToExecuteWhenYouNeedToUpdateYourCell(indexPath);
            break;
            
        case NSFetchedResultsChangeMove:
            [tableV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableV insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
