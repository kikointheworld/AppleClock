//
//  WorldClockViewController.swift
//  AppleClock
//
//  Created by 김선재 on 02.04.24.
//

import UIKit

class WorldClockViewController: UIViewController {

    @IBOutlet weak var worldClockTableView: UITableView!
    
    var timer: Timer?
    
    var list = [
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier:"Europe/Paris")!,
        TimeZone(identifier:"America/New_York")!,
        TimeZone(identifier:"Asia/Tehran")!,
        TimeZone(identifier: "Asia/Vladivostok")!
    ]
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        worldClockTableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in guard Date.now.minuteChanged, let self else { return }
            
            for cell in self.worldClockTableView.visibleCells {
                guard let clockCell = cell as? WorldClockTableTableViewCell else {continue}
                guard let indexPath = self.worldClockTableView.indexPath(for: cell) else {continue}
                
                let target = list[indexPath.row]
                clockCell.timeLabel.text = target.currentTime
                clockCell.timePeriodLabel.text = "  \(target.timePeriod ?? "")"
                clockCell.timeOffsetLabel.text = target.timeOffset
            }
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
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
        cell.timePeriodLabel.text = "  \(target.timePeriod ?? "")"
        cell.timeZoneLabel.text = target.city
        cell.timeOffsetLabel.text = target.timeOffset
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // 이메소드를 쓰면 리오더 기능이 추가됨 밑에 두줄은 이 변경사항 저장하기 위함.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let target = list.remove(at: sourceIndexPath.row)
        
        list.insert(target, at: destinationIndexPath.row)
    }
}
