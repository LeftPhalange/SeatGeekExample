//
//  DetailViewController.swift
//  SeatGeekExample
//
//  Created by Ethan Bovard on 4/21/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var eventLocationLabel: UILabel!
    var eventTitle: String
    var date: String
    var location: String
    var eventImage: UIImage
    var liked: Bool
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        self.eventTitleLabel?.text = eventTitle;
        self.eventDateTimeLabel?.text = date;
        self.eventLocationLabel?.text = location;
        self.eventImageView?.image = eventImage;
        if (self.liked) {
            setToLiked();
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        toggleLikeButton();
    }
    
    init (date: String, eventTitle: String, location: String, eventImage: UIImage, liked: Bool) {
        self.eventTitle = eventTitle;
        self.date = date;
        self.location = location;
        self.eventImage = eventImage;
        self.liked = liked;
        self.eventImageView?.clipsToBounds = true;
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        // use other init, this is the default
        self.eventTitle = "";
        self.date = "";
        self.location = "";
        self.eventImage = UIImage();
        self.liked = true;
        super.init(coder: coder);
    }
    
    func setToLiked () {
        likeButton?.setImage( UIImage(systemName: "heart.fill"), for: .normal);
        likeButton?.tintColor = .red;
        likeButton?.setNeedsLayout()
    }
    
    func toggleLikeButton () {
        liked.toggle();
        likeButton?.setImage((self.liked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")), for: .normal);
        likeButton?.tintColor = self.liked ? .red : .black
    }
}
