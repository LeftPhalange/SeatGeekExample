//
//  ViewController.swift
//  SeatGeekExample
//
//  Created by Ethan Bovard on 4/17/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var isSearching = false;
    
    // For this coding exercise, client ID and secrets are included
    var baseUrlEvents = "https://api.seatgeek.com/";
    var eventList: [EventItem] = []
    var eventListFiltered: [EventItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate();
        updateEventList()
        setUpTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count == 0) {
            self.isSearching = false;
            searchBar.showsCancelButton = false;
            searchBar.endEditing(true);
            self.tableView.reloadData();
        }
        else {
            let searchTextSplit = searchText.split(separator: " ");
            searchBar.showsCancelButton = true;
            self.isSearching = true;
            self.eventListFiltered.removeAll();
            for event in eventList {
                for token in searchTextSplit {
                    if (event.title.contains(token)) {
                        self.eventListFiltered.append(event);
                        break;
                    }
                }
            }
            self.tableView.reloadData();
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.count == 0) {
            self.isSearching = false;
            self.tableView.reloadData();
        }
    }
    
    // set preferredStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateEventList () {
        var urlComponents = URLComponents(string: baseUrlEvents)!
        urlComponents.path = "/2/events/";
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Seatgeek.clientId),
            URLQueryItem(name: "client_secret", value: Seatgeek.clientSecret)
        ];
        let url = urlComponents.url!;
        print (url.absoluteURL)
        self.eventList.removeAll();
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                for case let event in json["events"] as! [[String: Any]] {
                    let eventObj = Event.init(json: event)
                    print (eventObj!.performers.images[0]);
                    let eventItem = EventItem(title: eventObj!.title, location: eventObj!.venue.displayLocation, date: eventObj!.localDate, image: UIImage(), liked: false);
                    self.eventList.append(eventItem)
                    self.downloadImage(url: URL(string: eventObj!.performers.images[0])!, index: self.eventList.count-1);
                    DispatchQueue.main.async {
                        self.tableView.reloadData();
                    }
                }
            }
            else {
                print ("JSON data is nil")
            }
        }).resume();
    }
    
    func downloadImage (url: URL, index: Int) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            self.eventList[index].image = UIImage(data: data!)!
        }).resume();
    }
    
    /* Table view related stuff, delegate, data source and their protocol stubs */
    
    func setUpTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        // also set up search bar delegate
        searchBar.delegate = self
        // register tableView
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? eventListFiltered.count : eventList.count;
    }
    
    // Select callback for each row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = isSearching ? self.eventListFiltered[indexPath.row] : self.eventList[indexPath.row];
        let liked = self.isSearching ? self.eventListFiltered[indexPath.row].liked : self.eventList[indexPath.row].liked;
        let cellDetailView = DetailViewController(date: self.returnProperDate(date: cell.date), eventTitle: cell.title, location: cell.location, eventImage: cell.image, liked: liked);
        self.present(cellDetailView, animated: true);
    }
    
    func returnProperDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy h:mm a";
        return dateFormatter.string(from: date);
    }
    
    // Set up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        // Configure the cell’s contents.
        let referenceEventList: [EventItem] = isSearching ? self.eventListFiltered : self.eventList
        cell.eventTitleLabel?.text = referenceEventList[indexPath.row].title;
        cell.eventLocationLabel?.text = referenceEventList[indexPath.row].location;
        cell.eventDateTimeLabel?.text = self.returnProperDate(date: referenceEventList[indexPath.row].date);
        cell.eventImageView?.image = referenceEventList[indexPath.row].image;
        cell.eventLikeButton?.addAction(UIAction(handler: { (action) in
            if (self.isSearching) {
                self.eventListFiltered[indexPath.row].liked.toggle();
            } else {
                self.eventList[indexPath.row].liked.toggle();
            }
        }), for: .primaryActionTriggered);
        return cell
    }
}
