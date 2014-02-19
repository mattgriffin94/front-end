#import <UIKit/UIKit.h>


//User Interface Elements that my code needs to get data from

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (nonatomic,retain) IBOutlet UITextView *messageBox;

//labels next to text boxes

@property (nonatomic,retain) IBOutlet UILabel *usernameLabel;

@property (nonatomic,retain) IBOutlet UILabel *passwordLabel;

//text fields for user input

@property (nonatomic,retain) IBOutlet UITextField *usernameField;

@property (nonatomic,retain) IBOutlet UITextField *passwordField;

//buttons

@property (nonatomic,retain) IBOutlet UIButton *loginButton;

@property (nonatomic,retain) IBOutlet UIButton *logoutButton;

@property (nonatomic,retain) IBOutlet UIButton *addUserButton;


@end
