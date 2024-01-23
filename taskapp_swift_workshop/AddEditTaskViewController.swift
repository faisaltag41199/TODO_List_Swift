//
//  AddEditTaskViewController.swift
//  taskapp_swift_workshop
//
//  Created by Faisal TagEldeen on 05/01/2024.
//

import UIKit

class AddEditTaskViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var task: Task?
    var editTask: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initAddEditTaskScreenUIElements()
    }
    
    func initAddEditTaskScreenUIElements(){
        
        if !editTask {
            
            task = Task()
            datePicker.minimumDate = Date()
            
        } else {
            
            
            print("task title is is is is is  \(task?.title!)")
            screenTitle.text = "Edit Task"
            addButton.setTitle("Edit Task", for: .normal)

            titleTextField.text = task?.title
            descriptionTextField.text = task?.taskDescription

            // Priority of task
            switch task?.priority {

            case "Low":
                prioritySegmentedControl.selectedSegmentIndex = 0
                imageView.image = UIImage(named: "low.png")

            case "Medium":
                prioritySegmentedControl.selectedSegmentIndex = 1
                imageView.image = UIImage(named:"med.png")

            case "High":
                prioritySegmentedControl.selectedSegmentIndex = 2
                imageView.image = UIImage(named:"high.png")

            default:
                break
            }

            print(task?.status)

            // Segments
            switch task?.status {
                

            case "New":
                statusSegmentedControl.setEnabled(true, forSegmentAt: 1)
                statusSegmentedControl.setEnabled(true, forSegmentAt: 2)
                statusSegmentedControl.selectedSegmentIndex = 0

            case "In Prgoress":
                statusSegmentedControl.selectedSegmentIndex = 1
                statusSegmentedControl.setEnabled(true,forSegmentAt: 2)
                print("In Progress")

            default:
                statusSegmentedControl.selectedSegmentIndex = 2
            }

            datePicker.date = task?.date ?? Date()
        }
        
    }
    
    @IBAction func addOrEditTask(_ sender: Any) {
        
        if (titleTextField?.text?.isEmpty)! {
            showTitleValidatorAlert()
        } else {
            if editTask {
                showAlert(message: "Edit Task", title: "Do you want to Edit Task?")
            } else {
                showAlert(message: "Add Task", title: "Do you want to add Task?")
            }
        }
    }
    
    func showTitleValidatorAlert() {
        let alertController = UIAlertController(title: "Title Validator", message: "Title can't be empty", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("ok////")
        }

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message: String,title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if self.editTask {
                self.editAndSaveTask()
            } else {
                self.saveTask()
            }

            self.navigationController?.popViewController(animated: true)
            print("ok////")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel////")
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func saveTask(){
        
     
        prepareTask()
        
        let userdefaults = UserDefaults.standard
        var lastId = userdefaults.integer(forKey:"Last_Id_Key")
        lastId += 1
        userdefaults.set(lastId ,forKey:"Last_Id_Key")
        
        task?.taskId = lastId
        
        let retrievedObject = userdefaults.object(forKey:"Stored_Tasks_Key")
        
        if(retrievedObject != nil){
            
            var storedTasks:[Task]? = try? JSONDecoder().decode([Task].self, from: retrievedObject as! Data)
                
            storedTasks?.append(task!)
                
            let newData = try? JSONEncoder().encode(storedTasks)
            userdefaults.set(newData, forKey:"Stored_Tasks_Key")
        
        }else{
            
            var newTasks:[Task]=[]
            newTasks.append(task!)
        
            let newData = try? JSONEncoder().encode(newTasks)
            userdefaults.set(newData, forKey:"Stored_Tasks_Key")
        }
        
    }

    
    func editAndSaveTask(){
        
        prepareTask()
        let userdefaults = UserDefaults.standard
        let retrievedObject = userdefaults.object(forKey:"Stored_Tasks_Key")
        var storedTasks:[Task]? = try? JSONDecoder().decode([Task].self, from: retrievedObject as! Data)
        
        let index:Int? = storedTasks?.firstIndex(where: { $0.taskId == task?.taskId })
        storedTasks?[index!] = task!
        
        let newData = try? JSONEncoder().encode(storedTasks)
        userdefaults.set(newData, forKey:"Stored_Tasks_Key")

    }
    
    func prepareTask(){
        
        task?.title = titleTextField.text
        task?.taskDescription = descriptionTextField.text

        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0:
            task?.priority = "Low"
        case 1:
            task?.priority = "Medium"
        case 2:
            task?.priority = "High"
        default:
            break
        }

        if editTask {
            
            print("index \(statusSegmentedControl.selectedSegmentIndex) ")

            switch statusSegmentedControl.selectedSegmentIndex {
                
                case 0:
                    task?.status = "New" ;
                    print("prepare task for save")
                    print(task?.status)
                
                case 1:
                    task?.status = "In Prgoress";
                    print("prepare task for save")
                    print(task?.status)
                    
                case 2:
                    task?.status = "Done";
                    print("prepare task for save")
                    print(task?.status)
                
                default:
                    break
            }
            
        }else{
            task?.status = "New"
        }
        
        task?.date = datePicker.date
    }
    
    
    
}
