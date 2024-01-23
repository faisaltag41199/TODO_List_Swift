//
//  DoneViewController.swift
//  taskapp_swift_workshop
//
//  Created by Faisal TagEldeen on 05/01/2024.
//

import UIKit

class DoneViewController: UIViewController,
                          UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task]?
    var userDefaults: UserDefaults?
    var statusTasks: [Task]?
    var lowTaskArray: [Task]?
    var medTaskArray: [Task]?
    var highTaskArray: [Task]?
    var isFilterEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userDefaults = UserDefaults.standard
        tableView.delegate = self
        tableView.dataSource = self

        lowTaskArray = []
        medTaskArray = []
        highTaskArray = []

        isFilterEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let retrievedObject = userDefaults?.data(forKey:"Stored_Tasks_Key")
        if(retrievedObject == nil){
            tasks = []
        }else{
            
            tasks = try? JSONDecoder().decode([Task].self, from: retrievedObject!)

        }
        statusTasks = []
            
        for temp in tasks! {
            
            if temp.status == "Done" {
                statusTasks?.append(temp)
            }
        }

        if isFilterEnabled {
            lowTaskArray = []
            medTaskArray = []
            highTaskArray = []

            for temp in statusTasks! {
            
                if temp.priority == "Low" {
                    print("low")
                    lowTaskArray?.append(temp)
                } else if temp.priority == "Medium" {
                    print("med")
                    medTaskArray?.append(temp)
                } else {
                    print("high")
                    highTaskArray?.append(temp)
                }
                
            }
        }

        tableView.reloadData()
    }
    
    
    @IBAction func startFilter(_ sender: Any) {
        
        lowTaskArray = []
        medTaskArray = []
        highTaskArray = []
        
        if !isFilterEnabled {
            
            print("_isFilterEnabled yes")
            isFilterEnabled = true
            
            for temp in statusTasks! {
                if temp.priority == "Low" {
                    print("low")
                    lowTaskArray?.append(temp)
                } else if temp.priority == "Medium" {
                    print("med")
                    medTaskArray?.append(temp)
                } else {
                    print("high")
                    highTaskArray?.append(temp)
                }
            }
            
            tableView.reloadData()
        } else {
            isFilterEnabled = false
            tableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(isFilterEnabled){
            return 3;
        }
        
        return 1;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFilterEnabled {
            
            switch section {
                case 0:
                    print("lowTaskArray")
                    print(lowTaskArray?.count)
                    return "Low Priority Tasks"
                case 1:
                    print("medTaskArray")
                    print(medTaskArray?.count)
                    return "Medium Priority Tasks"
                case 2:
                    print("highTaskArray")
                    print(highTaskArray?.count)
                    return "High Priority Tasks"
                default:
                    break
            }
        }
        
        return  "All Tasks"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFilterEnabled {
            
            switch section {
                case 0:
                    return lowTaskArray?.count ?? 0
                case 1:
                    return medTaskArray?.count ?? 0
                case 2:
                    return highTaskArray?.count ?? 0
                default:
                    return statusTasks?.count ?? 0
            }
        }
        
        return statusTasks?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell", for: indexPath)

        var task: Task

        if isFilterEnabled {
            switch indexPath.section {
            case 0:
                task = (lowTaskArray?[indexPath.row])!
            case 1:
                task = (medTaskArray?[indexPath.row])!
            case 2:
                task = (highTaskArray?[indexPath.row])!
            default:
                fatalError("Invalid section")
            }
        } else {
            task = (statusTasks?[indexPath.row])!
        }

        var image: UIImage

        switch task.priority {
        case "Low":
            image = UIImage(named: "low.png")!
        case "Medium":
            image = UIImage(named: "med.png")!
        case "High":
            image = UIImage(named: "high.png")!
        default:
            image = UIImage() // Set a default image or handle the case appropriately
        }

        cell.imageView?.image = image
        cell.textLabel?.text = task.title

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let addEditVC = storyboard?.instantiateViewController(withIdentifier: "addEditVC") as? AddEditTaskViewController {
            addEditVC.editTask = true
            
            if isFilterEnabled {
                switch indexPath.section {
                case 0:
                    addEditVC.task = lowTaskArray?[indexPath.row]
                case 1:
                    addEditVC.task = medTaskArray?[indexPath.row]
                case 2:
                    addEditVC.task = highTaskArray?[indexPath.row]
                default:
                    fatalError("Invalid section")
                }
            } else {
                addEditVC.task = statusTasks?[indexPath.row]
            }
            
            navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            
            showAlert(message: "Do you want to delete this task", title: "delete task ", forRowAtIndexPath: indexPath)
        }
    }
    
    func showAlert(message: String,title: String, forRowAtIndexPath indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }

            if self.isFilterEnabled {
                
                switch indexPath.section {
                case 0:
                    self.deleteTask(removedTask:(self.lowTaskArray?[indexPath.row])!)
                case 1:
                    self.deleteTask(removedTask:(self.medTaskArray?[indexPath.row])!)
                case 2:
                    self.deleteTask(removedTask:(self.highTaskArray?[indexPath.row])!)
                default:
                    fatalError("Invalid section")
                }
            } else {
                
                self.deleteTask(removedTask:(self.statusTasks?[indexPath.row])!)
            }

            print("ok////")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel////")
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func deleteTask(removedTask: Task) {
        

        do {
            //retrieve
            let retrievedObject = userDefaults?.data(forKey:"Stored_Tasks_Key")
            var temporaryRetrivedTasks:[Task] = try JSONDecoder().decode([Task].self, from: retrievedObject!)
            
            var newTasksAfterDelete:[Task] = []
            // delete and update
            
            for oldTask in temporaryRetrivedTasks {
                if oldTask.taskId == removedTask.taskId {
                    continue
                } else {
                    newTasksAfterDelete.append(oldTask)
                    print("oldTask")
                }
            }
            //store
            let newData = try? JSONEncoder().encode(newTasksAfterDelete)
            userDefaults?.set(newData, forKey:"Stored_Tasks_Key")

           } catch {
             print(error)
           }

        reloadDataAfterDeleteTask()
    }

    func reloadDataAfterDeleteTask(){
        
        do {
            
            let retrievedObject = userDefaults?.data(forKey:"Stored_Tasks_Key")
            tasks = try JSONDecoder().decode([Task].self, from: retrievedObject!)
                   
           }
           catch {
             print(error)
           }
        
        statusTasks = []

        
        for temp in tasks! {
    
            if temp.status == "Done"{
                statusTasks?.append(temp)
            }
        }
        
        if isFilterEnabled {
            
            lowTaskArray = []
            medTaskArray = []
            highTaskArray = []

            for temp in statusTasks! {
            
                if temp.priority == "Low" {
                    print("low")
                    lowTaskArray?.append(temp)
                } else if temp.priority == "Medium" {
                    print("med")
                    medTaskArray?.append(temp)
                } else {
                    print("high")
                    highTaskArray?.append(temp)
                }
            }
        }
        
        tableView.reloadData()
    }

}
