//
//  ViewController.swift
//  RDiddysPaintStudio
//
//  Created by Rohit Didwania on 2/16/19.
//  Copyright © 2019 Rohit Didwania. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
   
    let sheet = SheetView()
    private var animationDuration = 0.2
    private var colors = [UIColor.init(r: 0, g: 0, b: 0), UIColor.init(r: 255, g: 255, b: 255), UIColor.init(r: 255, g: 192, b: 203), UIColor.init(r: 0, g: 128, b: 128), UIColor.init(r: 255, g: 228, b: 225), UIColor.init(r: 255, g: 0, b: 0), UIColor.init(r: 255, g: 215, b: 0), UIColor.init(r: 211, g: 255, b: 206), UIColor.init(r: 0, g: 255, b: 255),UIColor.init(r: 64, g: 224, b: 208), UIColor.init(r: 255, g: 115, b: 115), UIColor.init(r: 230, g: 230, b: 250), UIColor.init(r: 0, g: 0, b: 255),UIColor.init(r: 240, g: 248, b: 255), UIColor.init(r: 255, g: 165, b: 0), UIColor.init(r: 176, g: 224, b: 230), UIColor.init(r: 238, g: 238, b: 238), UIColor.init(r: 204, g: 204, b: 204), UIColor.init(r: 127, g: 255, b: 212), UIColor.init(r: 51, g: 51, b: 51), UIColor.init(r: 192, g: 192, b: 192), UIColor.init(r: 0, g: 51, b: 102),UIColor.init(r: 128, g: 0, b: 128),UIColor.init(r: 128, g: 0, b: 0), UIColor.init(r: 102, g: 205, b: 170), UIColor.init(r: 25, g: 25, b: 112), UIColor.init(r: 204, g: 255, b: 0), UIColor.init(r: 51, g: 153, b: 255), UIColor.init(r: 255, g: 127, b: 80), UIColor.init(r: 246, g: 84, b: 106)]

    @IBOutlet var colorCollectionViewConstraint : NSLayoutConstraint!
    @IBOutlet var toolViewConstraint : NSLayoutConstraint!
    @IBOutlet var segControlConstraint : NSLayoutConstraint!
    @IBOutlet var mapViewConstraint : NSLayoutConstraint!
  
    @IBOutlet weak var colorCollectionView : UICollectionView!
    @IBOutlet weak var pickColorButton : UIButton!
    @IBOutlet weak var hideToolsButton: UIButton!
    @IBOutlet weak var locationButton : UIButton!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var map : MKMapView!
    
    @IBOutlet weak var dashedLineSegControl: UISegmentedControl!
    @IBOutlet weak var dragToDrawLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var stayDown = false
    
    @IBOutlet weak var verticalSlider: UISlider!{
        didSet{
            //flip it horizontally
            verticalSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpColorCollectionView()
        newSheet()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func openPicker(){
        self.openPicker(open: self.colorCollectionViewConstraint.isActive)
        self.colorCollectionViewConstraint.isActive ? (self.pickColorButton.setImage(UIImage.init(named: "paintpallete"), for: .normal)) : (self.pickColorButton.setImage(UIImage.init(named: "filledInPallet"), for: .normal))
        UIView.animate(withDuration: self.animationDuration) {
            self.colorCollectionViewConstraint.isActive ? (self.pickColorButton.transform = CGAffineTransform.identity) : (self.pickColorButton.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3))
        }
        self.animateHide(self.locationButton, hide: !self.colorCollectionViewConstraint.isActive)
        setUpColorCollectionView()
        

    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let currentPenSize = (sender.value) * 10
        sheet.penWidth = CGFloat.init(currentPenSize)
        //update our sheet
        sheet.setNeedsDisplay()
    }
    
    @IBAction func segmentedControllerChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.sheet.dashMode = false
        case 1:
            self.sheet.dashMode = true
        default:
            self.sheet.dashMode = false
        }
        sheet.setNeedsDisplay()
    }
    
    @IBAction func clearSheet(){
        if self.sheet.lines.count > 0 {
            let deleteAlert = UIAlertController.init(title: "Are you sure you want to delete your hard work?", message: "This cannot be reversed later", preferredStyle: .alert)
            deleteAlert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (_) in
                self.sheet.lines = []
                self.animateHide(self.dragToDrawLabel, hide: self.sheet.lines.count > 0)
                self.sheet.setNeedsDisplay()
            }))
            deleteAlert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(deleteAlert, animated: true , completion: nil)
        }
       
    }
    
    @objc func animateHide(_ view : UIView, hide : Bool){
        view.isHidden = hide
        let alpha = hide ? 0 : 1
        UIView.animate(withDuration: self.animationDuration) {
            view.alpha = CGFloat(alpha)
        }
    }
    
    func toggleTools(hide: Bool) {
        self.animateHide(self.dragToDrawLabel, hide: self.sheet.lines.count > 0)
        animateHide(self.verticalSlider, hide: hide)
        if !stayDown { self.toolViewConstraint.isActive = hide ; flipHideToolsButton() }
        self.segControlConstraint.isActive = hide
        UIView.animate(withDuration: self.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func stowAwayTools(_ sender: Any) {
        self.toolViewConstraint.isActive = !self.toolViewConstraint.isActive
        self.stayDown = self.toolViewConstraint.isActive ? (true) : (false)
        UIView.animate(withDuration: self.animationDuration) {
            self.view.layoutIfNeeded()
        }
        flipHideToolsButton()
    }
    
    fileprivate func flipHideToolsButton(){
        UIView.animate(withDuration: self.animationDuration) {
            self.hideToolsButton.transform = self.toolViewConstraint.isActive ? ( CGAffineTransform(rotationAngle: .pi)) : (CGAffineTransform.identity)
        }
    }
    
    @IBAction func toggleMapView(){
        setUpMap()
        self.mapViewConstraint.isActive = !self.mapViewConstraint.isActive
        UIView.animate(withDuration: self.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func newSheet(){
        self.sheet.backgroundColor = UIColor.init(r: 50, g: 50, b: 50)
        self.sheet.frame = self.view.frame
        self.view.addSubview(sheet)
        sheet.delegate = self
        [self.verticalSlider, self.toolView, self.dragToDrawLabel, self.dashedLineSegControl, self.hideToolsButton ,self.mapView].forEach { (view) in
            self.view.bringSubviewToFront(view)
        }
        self.view.layoutIfNeeded()
        self.toggleTools(hide: false)
        self.hideToolsButton.addSubtleBottomShadoow()
    }
    
    fileprivate func openPicker(open : Bool){
        self.colorCollectionViewConstraint.isActive = !open
        
        UIView.animate(withDuration: self.animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setUpMap(){
        self.map.delegate = self

        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //ask the manager to request users permission for location tracking
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
    }
    
    fileprivate func setUpColorCollectionView(){
        self.colorCollectionView.delegate = self
        self.colorCollectionView.dataSource = self
        self.colorCollectionView.register(UINib.init(nibName: "ColorViewCell", bundle: nil), forCellWithReuseIdentifier: "colorCell")
        self.colorCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        let color = self.colors[indexPath.row]
        cell.setColor(color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = self.colors[indexPath.row].cgColor
        sheet.currentColor = color
        sheet.setNeedsDisplay()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: collectionView.frame.size.height / 2, height: collectionView.frame.size.height / 2)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.map.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        self.map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Region Drawing"
        annotation.subtitle = "Current Location"
        self.map.addAnnotation(annotation)

    }

}

class ColorCell : UICollectionViewCell{
    @IBOutlet weak var colorView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeCircle()
        
    }
    
    @objc func makeCircle(){
        DispatchQueue.main.async {
            self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2
            self.colorView.layer.borderColor = UIColor.white.cgColor
            self.colorView.layer.borderWidth = 2.0
            self.colorView.clipsToBounds = true
        }
    }
    
    @objc func setColor(_ color : UIColor){
        DispatchQueue.main.async {
            self.colorView.backgroundColor = color
        }
    }
    
}
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UIView{
    @objc func addSubtleBottomShadoow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.masksToBounds = false
    }
}

