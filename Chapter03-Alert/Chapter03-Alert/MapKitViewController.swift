//
//  MapKitViewController.swift
//  Chapter03-Alert
//
//  Created by 신상우 on 2021/11/13.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController{
    override func viewDidLoad() {
        let mapkitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))// mapView 객체 생성
        //mapView의 넓이와 높이를 0 으로 한 이유 : contentViewConroller의 루트뷰로 지정하면 항상 화면을 다 채우는 방식으로 크기가 자동
        //으로 지정되기 때문에 따로 설정하는 값이 무의미 하기 때문이다.
        self.view = mapkitView //루트 뷰를 맵뷰로 지정
        self.preferredContentSize.height = 200
        
        //위/경도를 사용하여 위치정보 설정
        let pos = CLLocationCoordinate2D(latitude: 37.514322, longitude: 126.894623)
        //지도에서 보여줄 넓이 (숫자가 작을수록 좁은 범위를 확대해서 보여준다)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        //지도 영역을 정의
        let region = MKCoordinateRegion(center: pos, span: span)
        //지도 뷰에 표시
        mapkitView.region = region
        mapkitView.regionThatFits(region)
        //위치를 핀으로 표시
        let point = MKPointAnnotation()
        point.coordinate = pos
        mapkitView.addAnnotation(point)
    }
}
