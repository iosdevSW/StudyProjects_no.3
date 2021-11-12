//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 신상우 on 2021/11/08.
//

import UIKit

class MemoListVC: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트 객체의 참조 정보
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tableView의 행 개수 return
        let count = self.appDelegate.memolist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.appDelegate.memolist[indexPath.row] // row에 맞는 데이터 가져오기.
        let cellId = rowData.image == nil ? "memoCell" : "memoCellWithImage"
        //rowData 의 이미지가 있으면 memoCellWithImage , 없으면 memoCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        //셀 내용 구성
        cell.subject?.text = rowData.title
        cell.contents?.text = rowData.contents
        cell.img?.image = rowData.image
        
        //date 타입의 날짜를 포맷에 맞게 변경
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formmater.string(from: rowData.regdate!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.appDelegate.memolist[indexPath.row]
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoRead") as? MemoReadVC else
        { return }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
