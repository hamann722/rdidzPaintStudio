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
    private let colors = [UIColor.init(red: 197.0/255, green: 187.0/255, blue: 161.0/255, alpha: 1.0), UIColor.init(red: 66.0/255, green: 34.0/255, blue: 28.0/255, alpha: 1), UIColor.init(red: 84.0/255, green: 61.0/255, blue: 38.0/255, alpha: 1), UIColor.black, UIColor.white, UIColor.darkGray, UIColor.init(red: 70.0/255, green: 22.0/255, blue: 79.0/255, alpha: 1.0), UIColor.init(red: 62.0/255, green: 13.0/255, blue: 90.0/255, alpha: 1), UIColor.init(red: 137.0/255, green: 33.0/255, blue: 118.0/255, alpha: 1), UIColor.init(red: 181.0/255, green: 100/255.0, blue: 165.0/255, alpha: 1), UIColor.init(red: 166.0/255, green: 136.0/255, blue: 178.0/255, alpha: 1), UIColor.init(red: 203.0/255, green: 192.0/255, blue: 221.0/255, alpha: 1), UIColor.init(red: 141.0/255, green: 164.0/255, blue: 208.0/255, alpha: 1), UIColor.init(red: 0, green: 80.0/255, blue: 135.0/255, alpha: 1), UIColor.init(red: 0, green: 88.0/255, blue: 174.0/255, alpha: 1), UIColor.init(red: 0, green: 148.0/255, blue: 186.0/255, alpha: 1), UIColor.init(red: 51.0/255, green: 169.0/255, blue: 189.0/255, alpha: 1), UIColor.init(red: 153.0/255, green: 216.0/255, blue: 220.0/255, alpha: 1), UIColor.init(red: 0, green: 124.0/255, blue: 80.0/255, alpha: 1), UIColor.init(red: 90.0/255, green: 129.0/255, blue: 54.0/255, alpha: 1), UIColor.init(red: 64.0/255, green: 186.0/255, blue: 104.0/255, alpha: 1), UIColor.init(red: 121.0/255, green: 197.0/255, blue: 76.0/255, alpha: 1), UIColor.init(red: 149.0/255, green: 201.0/255, blue: 147.0/255, alpha: 1), UIColor.init(red: 205.0/255, green: 230.0/255, blue: 173.0/255, alpha: 1), UIColor.init(red: 180.0/255, green: 145.0/255, blue: 104.0/255, alpha: 1), UIColor.init(red: 223.0/255, green: 185.0/255, blue: 0, alpha: 1), UIColor.init(red: 248.0/255, green: 150.0/255, blue: 0, alpha: 1), UIColor.init(red: 251.0/255, green: 163.0/255, blue: 100.0/255, alpha: 1), UIColor.init(red: 244.0/255, green: 96.0/255, blue: 58.0/255, alpha: 1), UIColor.init(red: 211.0/255, green: 82.0/255, blue: 12.0/255, alpha: 1), UIColor.init(red: 176.0/255, green: 0, blue: 119.0/255, alpha: 1), UIColor.init(red: 235.0/255, green: 0, blue: 138.0/255, alpha: 1), UIColor.init(red: 202.0/255, green: 51.0/255, blue: 102.0/255, alpha: 1), UIColor.init(red: 249.0/255, green: 163.0/255, blue: 192.0/255, alpha: 1), UIColor.init(red: 240.0/255, green: 116.0/255, blue: 102.0/255, alpha: 1), UIColor.init(red: 252.0/255, green: 208.0/255, blue: 191.0/255, alpha: 1)]
    
    @IBOutlet var colorCollectionViewConstraint : NSLayoutConstraint!
    @IBOutlet weak var colorCollectionView : UICollectionView!

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
        return 36
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
