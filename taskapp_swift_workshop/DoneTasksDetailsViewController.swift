//
//  DoneTasksDetailsViewController.swift
//  taskapp_swift_workshop
//
//  Created by Faisal TagEldeen on 05/01/2024.
//

import UIKit

class DoneTasksDetailsViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var prioritySegmantControl: UISegmentedControl!
    
    @IBOutlet weak var statusSegmantControl: UISegmentedControl!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task:Task?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = task?.title
        descriptionLabel.text = task?.taskDescription

        switch task?.priority {
        case "Low":
            prioritySegmantControl.selectedSegmentIndex = 0
            imageView.image = UIImage(named: "low.png")
        case "Medium":
            prioritySegmantControl.selectedSegmentIndex = 1
            imageView.image = UIImage(named: "med.png")
        default:
            prioritySegmantControl.selectedSegmentIndex = 2
            imageView.image = UIImage(named: "high.png")
        }

        switch task?.status {
        case "New":
            statusSegmantControl.selectedSegmentIndex = 0
        case "In Progress":
            statusSegmantControl.selectedSegmentIndex = 1
        default:
            statusSegmantControl.selectedSegmentIndex = 2
        }

        datePicker.date = task?.date ?? Date()

    }
}
