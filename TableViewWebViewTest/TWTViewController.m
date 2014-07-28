
#import "TWTViewController.h"

static NSString *cellIdentifier = @"webViewCell";

@interface TWTViewController ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) NSArray *data;
@end


@implementation TWTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.cache) {
        self.cache = [NSMutableDictionary dictionary];
    }
    [self createDummyData];
}

/**
 *  ダミーデータ生成
 */
- (void)createDummyData
{
    self.data = @[
                    @{@"title": @"title1",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title2",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title3",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title4",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title5",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title6",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title7",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title8",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title9",  @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title10", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title11", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title12", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title13", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title14", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title15", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title16", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title17", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title18", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title19", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                    @{@"title": @"title20", @"url": @"http://bl.ocks.org/edom18/raw/c4922ac0e91516e67374/"},
                ];
}

/**
 *  セルのアップデート
 */
- (void)updateCell:(UITableViewCell *)cell
{
    UIWebView *webView = (UIWebView *)[cell.contentView viewWithTag:200];
    CGRect frame = cell.contentView.frame;
    frame.size.height = [self cellHeightForWebView:webView];
    webView.frame = frame;
    cell.contentView.frame = frame;
}

/**
 *  セルの高さ計算
 *
 *  @param webView 計算対象のUIWebView
 *
 *  @return WebViewの高さ
 */
- (NSInteger)cellHeightForWebView:(UIWebView *)webView
{
    NSString *javascript = @"document.documentElement.scrollHeight;";
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:javascript] integerValue];
    NSLog(@"height: %ld", height);
    return height;
}


#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = self.data[indexPath.row][@"title"];
    }
    
    NSString *uniqueKey = [NSString stringWithFormat:@"cellId-%ld-%ld", indexPath.section, indexPath.row];
    UIWebView *webView  = self.cache[uniqueKey];
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame:cell.contentView.bounds];
        webView.tag      = 200;
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        NSURL *url = [NSURL URLWithString:self.data[indexPath.row][@"url"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        self.cache[uniqueKey] = webView;
    }
    
    UIView *oldWebView = [cell.contentView viewWithTag:200];
    if (oldWebView) {
        [oldWebView removeFromSuperview];
    }
    [cell.contentView addSubview:webView];
    [self updateCell:cell];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uniqueKey = [NSString stringWithFormat:@"cellId-%ld-%ld", indexPath.section, indexPath.row];
    UIWebView *webView  = self.cache[uniqueKey];
    if (!webView) {
        return 44;
    }
    return [self cellHeightForWebView:webView];
}

#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.tableView reloadData];
}

@end
