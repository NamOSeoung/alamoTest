//
//  ViewController.swift
//  alamoT
//
//  Created by 남오승 on 2020/03/30.
//  Copyright © 2020 남오승. All rights reserved.
//

import UIKit
import Alamofire

// json에서 key값 설정
class AreaInfo {
    
    var area_name : String
    var area : String
    
    init(area_name:String , area:String) {
        self.area_name = area_name
        self.area = area
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Alamofire.request("http://api.eatjeong.com/v1/area/first", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300) //네트워크 통신코드
            .responseJSON{ response in
                switch response.result {
                    case .success(let value):
        //                print(value)
                        // 1. value로 받은 json array를 data 상수에 넣어준다.
                        // 2. userlists에 json array를 디코더 하여 배열로 넣어준다.
                        // 3. 배열로 들어간 값들을 for문을 통해 하나식 꺼내어 쓴다.
                        
                    do {
                        
                        //print(value is Any) //타입비교 : 변수 is 자료형

                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) //alamofire로 추출한 response 데아터 json으로 직렬화 작업.

                        //as = type casting
                        
                         if let parseJSON = try JSONSerialization.jsonObject(with: data) as? [String:Any], //직렬화 한 json데이터 파싱
                            let resultValue = parseJSON["message"] as? String, let resultCode = parseJSON["code"] as? Int, //파싱 한 json데이터에서 key 값으로 데이터 추출
                            let resultDataList = parseJSON["dataList"] as? [[String:Any]] //dataList는 Array형식으로 return 이라 타입캐스팅 시 주의할 것 [[]] 대괄호 두 번 감싸야 가능.
                                {
                                    print("result: ", resultValue)
                                    print("code: ", resultCode)
                                    
                                    var areaInfo:[AreaInfo] = []
                                    for areaDictionary in resultDataList {
                                        guard let area_name = areaDictionary["area_name"] as? String, let area = areaDictionary["area"] as?
                                            String else {continue}
                                        
                                        areaInfo.append(AreaInfo.init(area_name: area_name, area: area))
                                    }
                                    
                                    print(areaInfo.count)
                                    print(areaInfo[0].area)
                                    print(areaInfo[0].area_name)
                                }
                    } catch let error as NSError{
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                        break;
                    
                    }

        }
        
        
    }


}

