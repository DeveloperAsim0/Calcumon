//
//  ViewController.swift
//  Calcumon
//
//  Created by Sarin Swift on 2/6/19.
//  Copyright © 2019 sarinswift. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    let selection = UISelectionFeedbackGenerator()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let images = [#imageLiteral(resourceName: "Inspiration-01"), #imageLiteral(resourceName: "Inspiration-02"), #imageLiteral(resourceName: "Inspiration-03"), #imageLiteral(resourceName: "Inspiration-04"), #imageLiteral(resourceName: "Inspiration-05"), #imageLiteral(resourceName: "Inspiration-06"), #imageLiteral(resourceName: "Inspiration-07"), #imageLiteral(resourceName: "Inspiration-08"), #imageLiteral(resourceName: "Inspiration-09"), #imageLiteral(resourceName: "Inspiration-10")]
    let categories = ["Basic Math", "Addition", "Subtraction", "Multiplication", "Division", "Addition & Subtraction", "Division & Mulitplication", "Square Root", "Linear Equation", "Radicals"]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.decelerationRate = .fast
        
        transitioningDelegate = self
    }
}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.row]
        cell.titleLabel.text = categories[indexPath.row]
        return cell
    }
    
    // tap to select a cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = collectionViewLayout as? UltravisualLayout else {
            return
        }
        
        let offSet = layout.dragOffset * CGFloat(indexPath.item)
        
        // presenting the animation
        selectAnimation(offset: offSet)
        
        // pauses
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Presenting a navController to the singleCategoryVC
            let story = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let singleCategoryVC = story.instantiateViewController(withIdentifier: "singleCategoryView") as? SingleCategoryViewController else { return }
            let navController = UINavigationController(rootViewController: singleCategoryVC)
            navController.navigationBar.barTintColor = UIColor(patternImage: self.images[indexPath.row])
            singleCategoryVC.title = self.categories[indexPath.row]
            self.present(navController, animated: false, completion: nil)
            self.fadingViewAnimation()
        }
        // trigger the haptic feedback
        selection.selectionChanged()
    }
    
    func selectAnimation(offset: CGFloat) {
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
}

// This viewController is acting as the delegate
extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // animation duration sets the time where the ViewController pops up
        return AnimationController(animationDuration: 0.5, animationType: .present)
    }
}
