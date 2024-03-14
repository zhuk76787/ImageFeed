//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/14/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var extitButton: UIButton!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var idLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBAction func didTupExitButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
