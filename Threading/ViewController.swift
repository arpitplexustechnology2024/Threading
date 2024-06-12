//
//  ViewController.swift
//  Threading
//
//  Created by Arpit iOS Dev. on 11/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    var musics: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue.global()
        
        //  queueTesting()
       // syncWaitingGroup()
       // notifyDispatchGroup()
        
        queue.async {
            semaphore.wait()
            let music = self.downloadMusic(name: "Gulabi sadi!")
            self.musics.append(music)
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            self.saveMusics()
            self.musics.remove(at: 0)
            semaphore.signal()
        }
    }
    
    //MARK: -
    func downloadMusic(name: String) -> String {
        sleep(4)
        print("\(name) has been downloaded.")
        return name
    }
    
    func saveMusics() {
        sleep(2)
        print("Music have been saved.")
    }
    
    //MARK: - concurrent and serial
    func queueTesting() {
        let myQueue = DispatchQueue(label: "ArpitiOSDev.serial.queue", attributes: .concurrent)
        
        myQueue.async {
            print("Task 1 Started")
            for index in 1...5 {
                print("\(index) [Task-1] times 5 is \(index * 5)")
            }
            print("Task 1 finished")
        }
        
        myQueue.async {
            print("Task 2 Started")
            for i in 1...3 {
                print("\(i) [Task-2] times 5 is \(i * 5)")
            }
            print("Task 2 finished")
        }
    }
    
    //MARK: -
    func syncWaitingGroup() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async(group: group) {
            print("Start job 1")
            Thread.sleep(until: Date().addingTimeInterval(6))
            print("End job 1")
        }
        
        queue.async(group: group) {
            print("Start job 2")
            Thread.sleep(until: Date().addingTimeInterval(2))
            print("End job 2")
        }
        
        if group.wait(timeout: .now() + 5) == .timedOut {
            print("I got tired of waiting")
        } else {
            print("All the jobs have completed")
        }
    }
    
    
    //MARK: -
    func notifyDispatchGroup() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.company.app")
        let somQueue = DispatchQueue(label: "com.company.app")
        
        queue.async(group: group) {
            for _ in 0...5 {
                print("Queue:- Task one running")
            }
        }
        queue.async(group: group) {
            for _ in 0...10 {
                print("Queue:- Task two running")
            }
        }
        somQueue.async(group: group) {
            for _ in 0...15 {
                print("SomQueue:- Task two running")
            }
        }
        group.notify(queue: DispatchQueue.main) {
            print("All jobs have completed")
        }
    }
}



