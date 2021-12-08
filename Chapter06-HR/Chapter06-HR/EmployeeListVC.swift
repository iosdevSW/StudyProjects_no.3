//
//  EmployeeListVC.swift
//  Chapter06-HR
//
//  Created by 신상우 on 2021/12/08.
//

import UIKit

class EmployeelistVC: UITableViewController {
    var empList: [EmployeeVO]!
    var empDAO = EmployeeDAO()
   
    var loadingImg: UIImageView!
    var bgCircle: UIView! //임계점에 도달했을 때 나타날 배경 뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.empList = self.empDAO.find()
        self.initUI()
        
        //당겨서 새로고침 기능
        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        //당겨서 새로고침 커스텀
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)! / 2 // 중앙에 오게 설정
        //y값은 아래로 당길수록 control의 높이또한 커지므로 스크롤되는 정도에따라 y값도 변해야 한다.
        //viewdidload보단 동적으로 변경가능한 scrollViewDidLoadScroll메소드에서 한다.
        
        self.refreshControl?.tintColor = .clear //  기본 로딩 이미지 tintcolor를 제거하여 숨기기
        self.refreshControl?.addSubview(self.loadingImg) // 커스텀 로딩 이미지 뷰를 서브 뷰로 등록
        
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = .yellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
        
        self.refreshControl?.addSubview(self.bgCircle)
        self.refreshControl?.bringSubviewToFront(self.loadingImg)
        
    }
    // scroll이 발생할 때마다 처리할 내용을 여기에 작성
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //tableView의 bound가 변함에 따라 refreshControl의 frame은 반대로 변함.
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)// 스크롤에 의해 당겨진 거리 계산
        
        self.loadingImg.center.y = distance / 2 //새로고침 컨트롤의 높이는 당긴 거리와 같다.
        self.bgCircle.center.y = distance / 2
        //당긴 거리만큼 이미지가 회전하도록 설정
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadingImg.transform = ts
    }
    
    // scroll 뷰의 드래그가 끝났을 때 호출
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        self.empList = self.empDAO.find() //다시 불러옴
        self.tableView.reloadData()
        
        self.refreshControl?.endRefreshing() //당겨서 새로고침 기능 종료 (일정량 땅기면 beginRefreshoing은 자동 호출됨)
        
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5){
            self.bgCircle.frame.size.width = 80
            self.bgCircle.frame.size.height = 80
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.center.y = distance / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle?.frame.size.width)! / 2
        }
    }
    
    func initUI(){
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = .systemFont(ofSize: 14)
        navTitle.text = "사원 목록 \n" + "\(empList.count) 명"
        
        self.navigationItem.titleView = navTitle
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "사원 등록", message: "등록할 사원 정보를 입력해 주세요.", preferredStyle: .alert)
        alert.addTextField(){ $0.placeholder = "사원명" }
        
        let pickerVC = DepartPickerVC()
        alert.setValue(pickerVC, forKey: "contentViewController")
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default){ (_) in
            var param = EmployeeVO()
            param.departCd = pickerVC.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            param.stateCd = EmpStateType.ING
            
            if self.empDAO.create(param: param) {
                self.empList = self.empDAO.find()
                self.tableView.reloadData()
                
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원 목록 \n" + "\(self.empList.count) 명"
                }
            }
        })
        
        self.present(alert, animated: false)
    }

    @IBAction func editing(_ sender: Any) {
        if self.isEditing == false { // 편집모드가 아닐 때
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    
    //MARK:- delegate Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        
        cell?.textLabel?.text = rowData.empName + "(\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = .systemFont(ofSize: 14)
        
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = .systemFont(ofSize: 12)
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let empCd = self.empList[indexPath.row].empCd
        
        if empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
