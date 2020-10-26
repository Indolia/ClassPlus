//
//  EmployeeTableViewCell.swift
//  ClassPlus
//
//  Created by Rishi pal on 25/10/20.
//

import UIKit


protocol EmployeeTableViewCellActionDelegate: class {
    func openMoreOption(at index: Int)
}
class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet var profileBGView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var moreButton: UIButton!
    
    weak var delegate: EmployeeTableViewCellActionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiSetUp()
        // Initialization code
    }
    
    private func uiSetUp() {
        profileBGView.cornerRadius(with: 8)
        profileBGView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        profileBGView.layer.borderWidth = 0.75
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openMore(_ sender: UIButton) {
        delegate?.openMoreOption(at: sender.tag)
    }
    
    func setData(for employee: EmployeeModel, at index: Int, delegate: EmployeeTableViewCellActionDelegate) {
        let defualtImage = UIImage(named: "man.png")
        nameLabel.text = employee.fullName
        emailLabel.text = employee.email
        profileImageView.setImage(for: employee.avatar, placeholder: defualtImage) { (image) in}
        self.delegate = delegate
        self.moreButton.tag = index
    }
    
}
