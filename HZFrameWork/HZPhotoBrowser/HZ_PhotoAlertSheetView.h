//
//  HZ_PhotoAlertSheetView.h
//  AFNetworking
//
//  Created by 吴灶洲 on 2019/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OnClick)(NSInteger index);

@interface HZ_PhotoAlertSheetView : UIView
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *dataArray;
@property (nonatomic, copy) OnClick onClick;

- (void)show;
@end

NS_ASSUME_NONNULL_END
