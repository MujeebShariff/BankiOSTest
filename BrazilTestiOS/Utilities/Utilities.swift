//
//  Utilities.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation

import UIKit

public class Utilities {
  private var container: UIView = UIView()
  private var loadingView: UIView = UIView()
  private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  // Show customized activity indicator
  func showActivityIndicator(view: UIView) {
    container.frame = view.frame
    container.center = view.center
    container.tag = 100
    container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.25)
    
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = view.center
    loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.75)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    activityIndicator.style = UIActivityIndicatorView.Style.large
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    view.addSubview(container)
    activityIndicator.startAnimating()
  }
  
  // Hide activity indicator
  func hideActivityIndicator(view: UIView) {
    activityIndicator.stopAnimating()
    if let viewWithTag = view.viewWithTag(100) {
      viewWithTag.removeFromSuperview()
    } else {
      print("Loading view not removed!")
    }
  }
  
  // Define UIColor with hex value
  private func UIColorFromHex(rgbValue: UInt32, alpha: Double=1.0) -> UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
  }
}
