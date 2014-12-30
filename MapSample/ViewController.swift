//
//  ViewController.swift
//  MapSample
//
//  Created by hiedar68 on 2014/12/29.
//  Copyright (c) 2014年 hiedar68. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            var theCoordinate = CLLocationCoordinate2D(latitude: 37.810000, longitude: -122.477450)
            
            return theCoordinate
        }
    }

    var title: String! {
        get {
            return "You are here"
        }
    }
    
    var subtitle: String! {
        get {
            return "MyAnnotation"
        }
    }
    
    // MARK: class method
    class func createViewAnnotationForMapView(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView {
        println("annotation : \(annotation.title)")
        var returnedAnnotationView : MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(NSStringFromClass(MyAnnotation))
        
        if (returnedAnnotationView == nil) {
            returnedAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(MyAnnotation))
            
            println("reuseIdentifier : \(returnedAnnotationView?.reuseIdentifier)")

            returnedAnnotationView?.canShowCallout = true;
            println("\nreturnedAnnotationView.centerOffset : \(returnedAnnotationView?.centerOffset)\n")
            
            // returnedAnnotationView.imageはnil。Obj-Cではnilへのアクセスは無視されるが、
            // Swiftだと以下の実行時エラー。どう解決する？
            //   fatal error: unexpectedly found nil while unwrapping an Optional value
            // centerOffsetの設定を
            
//            returnedAnnotationView!.centerOffset = CGPointMake( returnedAnnotationView!.centerOffset.x + returnedAnnotationView!.image.size.width/2, returnedAnnotationView!.centerOffset.y - returnedAnnotationView!.image.size.height/2 )
        } else {
            returnedAnnotationView?.annotation = annotation;
        }
        
        return returnedAnnotationView!;
    }
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add Annotation
        var myAnnotation : MyAnnotation = MyAnnotation()
        println("title : \(myAnnotation.title),\nlat : \(myAnnotation.coordinate.latitude)")
        self.myMapView.addAnnotation(myAnnotation)
        
        // go to default location
        
        var newReagion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.786996, -122.440100), MKCoordinateSpanMake(0.112872, 0.109863))
        self.myMapView.setRegion(newReagion, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var returnedAnnotationView :MKAnnotationView? = MyAnnotation.createViewAnnotationForMapView(self.myMapView, annotation: annotation)
        
        returnedAnnotationView?.image = UIImage(named: "Image")
        // MARK: TODO 後でrightCalloutAccessoryViewにUIButton追加
        var leftButton : UIButton? = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as? UIButton

        returnedAnnotationView?.rightCalloutAccessoryView = leftButton
        
        // 画像の位置修正
        returnedAnnotationView!.centerOffset = CGPointMake( returnedAnnotationView!.centerOffset.x + returnedAnnotationView!.image.size.width/2, returnedAnnotationView!.centerOffset.y - returnedAnnotationView!.image.size.height/2 )
        
        return returnedAnnotationView
    }
}

