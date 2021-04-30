//
//  TableViewCell.swift
//  SeatGeekExample
//
//  Created by Ethan Bovard on 4/21/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLikeButton: UIButton!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    var liked = false;
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        toggleLikeButton()
    }
    
    func toggleLikeButton () {
        liked.toggle();
        eventLikeButton?.setImage((liked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")), for: .normal);
        eventLikeButton?.tintColor = liked ? .red : .black
    }
    
}
