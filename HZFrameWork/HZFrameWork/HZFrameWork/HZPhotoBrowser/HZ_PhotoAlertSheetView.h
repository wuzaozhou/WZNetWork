//
//  HZ_PhotoAlertSheetView.h
//  AFNetworking
//
//  Created by 吴灶洲 on 2019/4/17.
//

#import <UIKit/UIKit.h>
@class HZ_FontFile;
@class HZTool;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HZ_PhotoAlertSheetTypeNorm,
    HZ_PhotoAlertSheetTypeCancel,//带有取消按钮
} HZ_PhotoAlertSheetType;

typedef void(^OnClick)(NSInteger index);

@interface HZ_PhotoAlertSheetView : UIView
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign) HZ_PhotoAlertSheetType type;
@property (nonatomic, copy) NSArray<NSString *> *dataArray;
@property (nonatomic, copy) OnClick onClick;

- (void)show;
@end

NS_ASSUME_NONNULL_END
