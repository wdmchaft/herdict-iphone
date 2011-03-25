//
//  FormCell.m
//  Herdict
//
//  Created by Christian Brink on 3/24/11.
//  Copyright 2011 Herdict. All rights reserved.
//

#import "FormCell.h"


@implementation FormCell

@synthesize iconBackground;
@synthesize mainBackground;

@synthesize theIconView;

@synthesize cellLabel;
@synthesize cellDetailLabel;

@synthesize whiteScreen;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		//	Get rid of the default UITableViewCell backgroundView.
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		backView.backgroundColor = [UIColor clearColor];
		self.backgroundView = backView;
		self.backgroundColor = [UIColor clearColor];
		self.layer.cornerRadius = 5;		
		self.selectionStyle = UITableViewCellSelectionStyleNone;

		self.iconBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		self.iconBackground.backgroundColor = [UIColor whiteColor];
		self.iconBackground.layer.cornerRadius = 5;
		[self addSubview:self.iconBackground];
		self.mainBackground = [[UIView alloc] initWithFrame:CGRectMake(43, 0, 260-43, 40)];
		self.mainBackground.backgroundColor = [UIColor whiteColor];
		self.mainBackground.layer.cornerRadius = 5;
		[self addSubview:self.mainBackground];
		
		self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 4, 200, 18)];
		self.cellLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
		self.cellLabel.textColor = [UIColor blackColor];
		self.cellLabel.alpha = 0.85;
		self.cellLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellLabel];
		
		self.cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 20, 200, 17)];
		self.cellDetailLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
		self.cellDetailLabel.textColor = [UIColor grayColor];
		self.cellDetailLabel.alpha = 0.85;
		self.cellDetailLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.cellDetailLabel];
		
		self.theIconView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
		[self addSubview:self.theIconView];
		
		self.whiteScreen = [[UIView alloc] initWithFrame:self.frame];
		[self addSubview:self.whiteScreen];
		self.whiteScreen.backgroundColor = [UIColor whiteColor];
		self.whiteScreen.alpha = 0;
	}
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
