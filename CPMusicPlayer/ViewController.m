//
//  ViewController.m
//  CPMusicPlayer
//
//  Created by Student P_06 on 03/11/16.
//  Copyright © 2016 chaitu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isPlaying = false;
    self.sliderDuration.userInteractionEnabled = YES;
    self.sliderDuration.minimumValue = 0;
    self.sliderDuration.value = 0;
    
    [self.sliderDuration setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializationOfTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurationOfSlider) userInfo:nil repeats:YES];
    
}

-(void)updateDurationOfSlider {
    
    if (self.sliderDuration.value == audioPlayer.duration) {
        timer = nil;
    }
    self.sliderDuration.value = audioPlayer.currentTime;
}

-(BOOL)conditionOfPlayer{
    BOOL Status = false;

    NSURL *musicFileURl = [[NSBundle mainBundle]URLForResource:@"mySong" withExtension:@"mp3"];
    
    if(musicFileURl != nil){
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicFileURl error:&error];
        if (error !=  nil) {
            NSLog(@"Error:%@",error.localizedDescription);
            

        }
        else{
            
            self.sliderDuration.maximumValue = audioPlayer.duration;

            Status = true;
        }
    }
    
    
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:musicFileURl options:nil];
        
        NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
        NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
        NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
        
        AVMetadataItem *title = [titles objectAtIndex:0];
        AVMetadataItem *artist = [artists objectAtIndex:0];
        AVMetadataItem *albumName = [albumNames objectAtIndex:0];
    
    NSArray *metadata = [asset commonMetadata];
    
    
    for (AVMetadataItem *item in metadata) {
        if ([[item commonKey] isEqualToString:@"title"]) {
            titleOfSong = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"artist"]) {
            artistsOfSong = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"albumName"]) {
            albumNamesOfSong = (NSString *)[item value];
        }
    
   // NSLog(@"title:%@",title);
//    self.titleLabel.text = [NSString stringWithFormat:@"%@",title];
//    self.artistLabel.text = [NSString stringWithFormat:@"%@",artist];
//    self.albumNameLabel.text = [NSString stringWithFormat:@"%@",albumName];
        
        self.titleLabel.text =titleOfSong;
        self.artistLabel.text =artistsOfSong;
        self.albumNameLabel.text =albumNamesOfSong;

    }
        NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                               withKey:AVMetadataCommonKeyArtwork
                                                              keySpace:AVMetadataKeySpaceCommon];
            
            for (AVMetadataItem *item in artworks) {
                if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                   // NSDictionary *d = [item.value copyWithZone:nil];
                    
                    NSData *data = [item.value copyWithZone:nil];
                    UIImage *image = [UIImage imageWithData:data];
                    self.musicImage.image = image;
                } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                    self.musicImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                }
            }
        }];
        
    

    return Status;

}



- (IBAction)playAction:(id)sender {

//    UIButton *stateButton = sender;
//    //UIImage *buttonImage = [UIImage imageNamed:@"play.png"];
//
//    if ([stateButton.titleLabel.text isEqualToString:@"Play"]) {
//        
//    if (isPlaying) {
//        [audioPlayer play];
//    }
//    else{
//        if ([self conditionOfPlayer]) {
//            [audioPlayer play];
//            isPlaying=true;
//        }
//        else{
//            NSLog(@"Something went wrong...");
//            
//        }
//        
//    }
//    //if ([stateButton setImage:buttonImage forState:UIControlStateNormal]) {
//
//        [stateButton setTitle:@"Pause" forState:UIControlStateNormal];
//    }
//    else if ([stateButton.titleLabel.text isEqualToString:@"Pause"]) {
//        [audioPlayer pause];
//        isPlaying = false;
//        [stateButton setTitle:@"Play" forState:UIControlStateNormal];
//
//}
    UIButton *stateButton = sender;
    //UIImage *buttonImage = [UIImage imageNamed:@"play.png"];
    
    if ([stateButton.currentImage isEqual:[UIImage imageNamed:@"play.png"]]){

    
        if (isPlaying) {
            [audioPlayer play];
            [self initializationOfTimer];

        }
        else{
            if ([self conditionOfPlayer]) {
                [audioPlayer play];
                [self initializationOfTimer];

                isPlaying=true;
            }
            else{
                NSLog(@"Something went wrong...");
                
            }
            
        }
        [stateButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else if ([stateButton.currentImage isEqual:[UIImage imageNamed:@"pause.png"]])
{
        [audioPlayer pause];
    
        [timer invalidate];

        [stateButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }

}

- (IBAction)stopAction:(id)sender {
    
    [audioPlayer stop];
    isPlaying = false;
    self.sliderDuration.value = 0;
    [timer invalidate];
    timer = nil;

    [self.playStatus setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
}
@end
