//
//  TansactionTableViewCell.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 02/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import UIKit

public class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowOpacity = 0.4
        cardView.layer.shadowOffset = .zero
        self.cardView.layer.masksToBounds = false
        cardView.layer.shadowRadius = 5
        cardView.layer.cornerRadius = 6
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
