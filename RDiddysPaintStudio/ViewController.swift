//
//  ViewController.swift
//  RDiddysPaintStudio
//
//  Created by Rohit Didwania on 2/16/19.
//  Copyright © 2019 Rohit Didwania. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var animationDuration = 0.2
    private var colors = [UIColor.init(r: 0, g: 0, b: 0), UIColor.init(r: 255, g: 255, b: 255), UIColor.init(r: 255, g: 192, b: 203), UIColor.init(r: 0, g: 128, b: 128), UIColor.init(r: 255, g: 228, b: 225), UIColor.init(r: 255, g: 0, b: 0), UIColor.init(r: 255, g: 215, b: 0), UIColor.init(r: 211, g: 255, b: 206), UIColor.init(r: 0, g: 255, b: 255),UIColor.init(r: 64, g: 224, b: 208), UIColor.init(r: 255, g: 115, b: 115), UIColor.init(r: 230, g: 230, b: 250), UIColor.init(r: 0, g: 0, b: 255),UIColor.init(r: 240, g: 248, b: 255), UIColor.init(r: 255, g: 165, b: 0), UIColor.init(r: 176, g: 224, b: 230), UIColor.init(r: 238, g: 238, b: 238), UIColor.init(r: 204, g: 204, b: 204), UIColor.init(r: 127, g: 255, b: 212), UIColor.init(r: 51, g: 51, b: 51), UIColor.init(r: 192, g: 192, b: 192), UIColor.init(r: 0, g: 51, b: 102),UIColor.init(r: 128, g: 0, b: 128),UIColor.init(r: 128, g: 0, b: 0), UIColor.init(r: 102, g: 205, b: 170), UIColor.init(r: 25, g: 25, b: 112), UIColor.init(r: 204, g: 255, b: 0), UIColor.init(r: 51, g: 153, b: 255), UIColor.init(r: 255, g: 127, b: 80), UIColor.init(r: 246, g: 84, b: 106)]

    @IBOutlet var colorCollectionViewConstraint : NSLayoutConstraint!
    @IBOutlet weak var colorCollectionView : UICollectionView!
    @IBOutlet weak var verticalSlider: UISlider!{
        didSet{
            verticalSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpColorCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func openPicker(){
        self.openPicker(open: self.colorCollectionViewConstraint.isActive)
        setUpColorCollectionView()
    }
    
    fileprivate func openPicker(open : Bool){
        self.colorCollectionViewConstraint.isActive = !open
        
        UIView.animate(withDuration: self.animationDuration) {
            self.view.layoutIfNeeded()
        }
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
        //
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
