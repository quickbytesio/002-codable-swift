//
//  ViewController.swift
//  Quickbytes Example Swift
//
//  Created by Aaron Brethorst on 9/25/17.
//  Copyright © 2017 Quickbytes. All rights reserved.
//

import UIKit

struct Feed: Codable {
    let title: String
    let id: URL
    let copyright: String
    let country: String
    let icon: URL
    let updated: Date
    let results: [FeedItem]
}

struct FeedItem: Codable {
    let artistUrl: URL
    let artistId: String
    let artistName: String
    let artworkUrl100: URL
    let copyright: String
    let id: String
    let name: String
    let releaseDate: Date
    let url: URL
}

class ViewController: UIViewController, UITableViewDataSource {

    var feed: Feed?
    let tableView = UITableView.init()

    /// Decodes the `updated` fields in `Feed` structs.
    lazy var dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    /// Decodes the `releaseDate` fields in `FeedItem` structs.
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    /// Decodes a Feed with embedded `FeedItem`s
    // and multiple date formats.
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = self.dateTimeFormatter.date(from: dateString) {
                return date
            }

            if let date = self.dateFormatter.date(from: dateString) {
                return date
            }

            return Date()
        }
        return decoder
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.configureTableView()

        let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-apps-we-love/all/25/non-explicit.json")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("Error: \(String(describing: error))")
                return
            }

            let feedWrapper = try! self.decoder.decode([String: Feed].self, from: data)

            DispatchQueue.main.async {
                self.feed = feedWrapper["feed"]!
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }

    // MARK: - Table View

    private func configureTableView() {
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.frame = self.view.bounds
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feed = self.feed else {
            return 0
        }

        return feed.results.count
    }

    private static let cellReuseIdentifier = "identifier"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellReuseIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: ViewController.cellReuseIdentifier)
        }

        let feedItem = self.feed?.results[indexPath.row]

        cell?.textLabel?.text = feedItem?.name

        if let artistName = feedItem?.artistName {
            cell?.detailTextLabel?.text = "By \(artistName)"
        }
        else {
            cell?.detailTextLabel?.text = nil
        }

        return cell!
    }
}
