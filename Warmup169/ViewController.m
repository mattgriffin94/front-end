#import "ViewController.h"




@implementation ViewController


//Code that runs when our app starts up
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passwordField.delegate = self.usernameField.delegate = self;
    [self switchToLoginScreen];
}


//Method to ensure the keyboard closes when a user presses Return
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


//Switches to Login Screen
//Hides Logout Button, initializes message, etc
-(void)switchToLoginScreen {
    [self.messageBox setText:@"Please enter your credentials below"];
    [self.loginButton setHidden:NO];
    [self.addUserButton setHidden:NO];
    [self.logoutButton setHidden:YES];
    [self.usernameField setHidden:NO];
    [self.passwordField setHidden:NO];
    [self.passwordLabel setHidden:NO];
    [self.usernameLabel setHidden:NO];
}


//Switches to Success Screen
//Hides Login and Add User Buttons, shows Logout Buttons, etc
-(void)switchToSuccessScreen {
    [self.loginButton setHidden:YES];
    [self.addUserButton setHidden:YES];
    [self.logoutButton setHidden:NO];
    [self.usernameField setHidden:YES];
    [self.passwordField setHidden:YES];
    [self.passwordLabel setHidden:YES];
    [self.usernameLabel setHidden:YES];
}



//Code to handle button taps
-(IBAction)buttonPressed:(id)sender {
    
    NSDictionary *receivedDict;
    
    if(sender==self.logoutButton) { //logout button pressed
        
        [self switchToLoginScreen];
        
    }
    
    else if(sender==self.loginButton) { //login button pressed
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        receivedDict = [self performRequestToURL:@"http://agile-tundra-5428.herokuapp.com/users/login"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        switch ([[receivedDict objectForKey:@"errCode"] integerValue]) {
             
            //Got invalid user/pass error
            case -1:
                [self.messageBox setText:@"Invalid username and password combination. Please try again."];
                break;
                
            //success!
            case 1:
                [self.messageBox setText:[NSString stringWithFormat:@"Welcome %@\nYou have logged in %d times",self.usernameField.text,[[receivedDict objectForKey:@"count"] integerValue]]];
                [self switchToSuccessScreen];
        }
        
    }
    
    else { //Add User Button Pressed
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        receivedDict = [self performRequestToURL:@"http://agile-tundra-5428.herokuapp.com/users/add"];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        switch ([[receivedDict objectForKey:@"errCode"] integerValue]) {
                
            //User Exists
            case -2:
                [self.messageBox setText:@"This user name already exists. Please try again."];
                break;
                
            //Bad Username
            case -3:
                [self.messageBox setText:@"The user name should be non-empty and at most 128 characters long. Please try again."];
                break;
                
            //Badd Password
            case -4:
                [self.messageBox setText:@"The password should be at most 128 characters long. Please try again."];
                break;
            
            //success!
            case 1:
                [self.messageBox setText:[NSString stringWithFormat:@"Welcome %@\nYou have logged in %d times",self.usernameField.text,[[receivedDict objectForKey:@"count"] integerValue]]];
                [self switchToSuccessScreen];
        }
        
        
    }
    
    
}


//Code that sends an HTTP Post Request using a URL Passed in
//The Request Body is a JSON Dict with key values from the
//Username and Password fields in the app

-(NSDictionary*)performRequestToURL: (NSString*)urlString { //send request to our server
    
    //Set up JSON Dictionary
    NSMutableDictionary *keyDict = [NSMutableDictionary dictionary];
    [keyDict setValue:self.usernameField.text forKey:@"user"];
    [keyDict setValue:self.passwordField.text forKey:@"password"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:keyDict options:NSJSONWritingPrettyPrinted error:nil];
    
    //set up http request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    //Receive Response Response From Server
    NSURLResponse *response =nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *receivedDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",receivedDict);
    
    return receivedDict;
    
    

    
    
}




@end
