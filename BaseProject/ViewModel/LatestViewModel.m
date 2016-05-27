//
//  LatestViewModel.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "LatestViewModel.h"

@implementation LatestViewModel
-(id)initWithNewsListType:(NewsListType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSInteger)rowNumber{
    return self.dataArr.count;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray new];
    }
    return _dataArr;
}

- (NewsResultNewslistModel *)newsListModelForRow:(NSInteger)row{
    return self.dataArr[row];
}

- (NSURL *)iconURLForRow:(NSInteger)row{
    return [NSURL URLWithString:[self newsListModelForRow:row].smallpic];
}
- (NSString *)titleForRow:(NSInteger)row{
    return [self newsListModelForRow:row].title;
}
- (NSString *)dateForRow:(NSInteger)row{
    return [self newsListModelForRow:row].time;
}
- (NSString *)commentNumberForRow:(NSInteger)row{
    return [[self newsListModelForRow:row].replycount.stringValue stringByAppendingString:@"评论"];
}
- (NSNumber *)IDForRow:(NSInteger)row{
    return [self newsListModelForRow:row].ID;
}
/*20151026修改 ⬇️*/
- (NSNumber *)adIDForRow:(NSInteger)row{
//通过row 获取到对应的 focusimg 数据项
    NewsResultFocusimgModel *model = self.headImageURLs[row];
//从数据项中获得ID 返回
    return model.ID;
}
/*20151026修改 ⬆️*/
- (void)getDataCompleteHandle:(void (^)(NSError *))complete{
    [NewsNetManager getNewsListType:_type lastTime:_updateTime page:_page completionHandle:^(NewsModel *model, NSError *error) {
        if ([_updateTime isEqualToString:@"0"]) {
            [self.dataArr removeAllObjects];
        }
        [self.dataArr addObjectsFromArray:model.result.anewslist];
        /*20151026修改 ⬇️*/
        
        self.headImageURLs = [model.result.focusimg copy];
        /*20151026修改 ⬆️*/
        complete(error);
        
    }];
}

- (void)refreshDataCompleteHandle:(void (^)(NSError *))complete{
    _updateTime = @"0";
    _page = 1;
    [self getDataCompleteHandle:complete];
}

- (void)getMoreDataCompleteHandle:(void (^)(NSError *))complete{
    NewsResultNewslistModel *obj=self.dataArr.lastObject;
    _updateTime = obj.lasttime;
    _page += 1;
    [self getDataCompleteHandle:complete];
}

@end
















