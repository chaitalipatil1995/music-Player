//
//  ViewController.h
//  CPMusicPlayer
//
//  Created by Student P_06 on 03/11/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController

{
    AVAudioPlayer *audioPlayer;
    BOOL isPlaying;
}

- (IBAction)playAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *playStatus;
@property (strong, nonatomic) IBOutlet UIImageView *musicImage;

@end

