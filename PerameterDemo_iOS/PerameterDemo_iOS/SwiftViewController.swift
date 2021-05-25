//
//  SwiftViewController.swift
//  PerameterDemo_iOS
//
//  Created by 彭之耀 on 2021/5/25.
//

import UIKit

class SwiftViewController: UIViewController {
    
    var timer : DispatchSourceTimer?
    var _zs : Person!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let p = Person.init()
        p.name = "张三"
        p.address = "聚贤路"
        _zs = p
        self.say(p: p)
        nameTF.text =  p.name
        addressTF.text = p.address
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
        
        
    }
    
    
    
    @IBAction func change(_ sender: UIButton) {
        if let name = nameTF.text {
            _zs.name = name
        }
        if let address = addressTF.text {
            _zs.address = address
        }
        
    }
    
    
    func say(p:Person) {
        // 在global线程里创建一个时间源
        if timer == nil {
            timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        }
        // 设定这个时间源是每秒循环一次，立即开始
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        timer?.setEventHandler(handler: {
            print("swift---name:",p.name,"    address:",p.address)
            
            
        })
        // 启动时间源
        timer?.resume()
    }


    //停止定时器
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
