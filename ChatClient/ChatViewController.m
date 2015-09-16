//
//  ChatViewController.m
//  ChatClient
//
//  Created by Jagtej Sodhi on 9/16/15.
//  Copyright © 2015 Jagtej Sodhi. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse.h"
#import "MessageTableViewCell.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeMessage;
@property (weak, nonatomic) IBOutlet UIButton *composeButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) NSArray *messagesArray;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesTableView.delegate = self;
    self.messagesTableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector: @selector(updateMessages) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)composeClicked:(id)sender {
    NSString *message = [self.composeMessage text];
    
    PFObject *object = [PFObject objectWithClassName:@"Message"];
    object[@"text"] = message;
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Message saved successfully");
        }
        else {
            NSLog(@"Message not saved.");
        }
    }];
    
}

- (void) updateMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.messagesArray = objects;
        
        [self.messagesTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.jagtej.sodhi.messagecell" forIndexPath:indexPath];
    
    cell.messageText.text = self.messagesArray[indexPath.row][@"text"];
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
