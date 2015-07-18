//
//  ViewController.m
//  ImageStretch
//
//  Created by Vicky on 7/10/15.
//  Copyright (c) 2015 Jobs. All rights reserved.
//

/*********
 Use Observer to make the image strech like The QQ or Weibo
 ********/

#import "ViewController.h"
#import "UIView+Ext.h"
#define KNavigationHeight 64.0f
#define KTableViewHeaderHeight 270
#define KTableViewHeaderWidth 270
#define kScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define kScreeenHeight         [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *tableHeaderView;

@end

@implementation ViewController

#pragma mark LifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = [NSMutableArray array];
    for (int i = 1; i <=15; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"row:%ld",(long)i]];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreeenHeight) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.contentInset= UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIImage *image = [UIImage imageNamed:@"Image_NearBy_Default_Big"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KTableViewHeaderHeight)];
    _imageView.image  = image;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_imageView atIndex:0];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:_imageView.frame];
    _tableHeaderView.backgroundColor  =[UIColor clearColor];
    _tableView.tableHeaderView = _tableHeaderView;
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSInteger rowIndex  = indexPath.row;
    cell.textLabel.text = self.dataArray[rowIndex];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

#pragma mark Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGFloat yOffset =  point.y;
        if (yOffset < 0) {
            if (KTableViewHeaderHeight - yOffset <= kScreenWidth ) {
                // use (KTableViewHeaderHeight - yOffset <= kScreenWidth ) just make strech more smooth and natural
                _imageView.frame = CGRectMake(0, 0, kScreenWidth, KTableViewHeaderHeight - yOffset);
            }else{
                _imageView.frame = CGRectMake(0, 0, KTableViewHeaderHeight-yOffset, KTableViewHeaderHeight-yOffset);
            }
            _imageView.centerX = kScreenWidth/2.0f;
            if (self.tableView.tableHeaderView != _tableHeaderView) {
                  self.tableView.tableHeaderView = _tableHeaderView;
            }
        }else{
        _imageView.top = - yOffset;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
