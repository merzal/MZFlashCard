//
//  MZFlashCardPackChooser.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MZFlashCardPackChooser : UITableViewController 
{
    NSMutableArray* _cardPacks;
    //NSMutableArray* _cardPackTitles;
    UILabel*        _noPackLabel;
    
    //GoogleController data
    BOOL            _loggedIn;
    NSString*       _username;
    NSString*       _password;
}

@property (assign)  BOOL loggedIn;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;

- (void)addCardPackFromArray:(NSMutableArray*)pack withTitle:(NSString*)title;

@end
