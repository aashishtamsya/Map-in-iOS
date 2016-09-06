//
//  ViewController.m
//  ATMap
//
//  Created by Aashish Tamsya on 06/09/16.
//  Copyright © 2016 Aashish Tamsya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILongPressGestureRecognizer *longPressOnMap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressOnMap:)];
    longPressOnMap.minimumPressDuration = 2.0;

    [self.mapView addGestureRecognizer:longPressOnMap];
    
    locationManager = [[CLLocationManager alloc]init];
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleLongPressOnMap:(UIGestureRecognizer *)gesture {
    
    
    
    NSLog(@"Long Pressed on Map");
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [gesture locationInView:self.mapView];
        
        CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:gesture.view];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        
        annotation.coordinate = newCoordinate;
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@",error.localizedDescription);
                return;
            }
            
            if (placemarks.count > 0) {
                CLPlacemark *placemark = placemarks.firstObject;
                annotation.title = [placemark.thoroughfare stringByAppendingString:[NSString stringWithFormat:@", %@",placemark.subThoroughfare]];
                annotation.subtitle = placemark.locality;
                [self.mapView addAnnotation:annotation];
                
            }
            else {
                annotation.title = @"Unknown Place";
                [self.mapView addAnnotation:annotation];
                NSLog(@"Problem with the data received from geocoder");
            }
        }];
        
    }
    
}

- (IBAction)mapTypeAction:(id)sender {
    
    UISegmentedControl *segmentedControl = sender;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.mapView setMapType:MKMapTypeStandard];
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        [self.mapView setMapType:MKMapTypeSatellite];
    }
    else {
        [self.mapView setMapType:MKMapTypeHybrid];
    }
    
}

#pragma mark CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = locations.lastObject;
    
    NSLog(@"Lat : %f Long : %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
}

#pragma mark MapView Delegate Methods



@end
