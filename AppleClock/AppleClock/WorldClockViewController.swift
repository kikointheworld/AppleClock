//
//  WorldClockViewController.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var worldClockTableView: UITableView!
    
    var list = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier:"Europe/Paris")!,
        TimeZone(identifier:"America/New_York")!,
        TimeZone(identifier:"Asia/Tehran")!,
        TimeZone(identifier: "Asia/Vladivostok")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .timeZoneDidSelect, object: nil, queue: .main) {[weak self] noti in
            guard let self, let timeZone = noti.userInfo?["timeZone"] as? TimeZone else {
                return
            }
            guard !self.list.contains(where: {$0.identifier == timeZone.identifier}) else {
                return
            }
            self.list.append(timeZone)
            self.worldClockTableView.reloadData()
        }

        
        
    }
    


}

extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorldClockTableTableViewCell.self), for: indexPath) as! WorldClockTableTableViewCell
        
        let target = list[indexPath.row]
        cell.timeLabel.text = target.currentTime
        cell.timePeriodLabel.text = target.timePeriod
        cell.timeZoneLabel.text = target.city
        cell.timeOffsetLabel.text = target.timeOffset
        return cell
    }
}
