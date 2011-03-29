//
//  FormEditCell.m
//  Herdict
//
//  Created by Christian Brink on 3/29/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormEditCell.h"

@implementation FormEditCell

@synthesize theMessage;
@synthesize menuOptions;
@synthesize selectionBackground;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
