//
//  ClassA.swift
//  SwiftStudy
//
//  Created by weixin on 2021/12/6.
//

import Foundation

protocol People {
    var name: String {set get}
    var sex: String {set get}
    var height: Float {set get}
    
    func eat()
}

class Student: People {
    var name: String = ""
    var sex: String = ""
    var height: Float = 0.0
    
    func eat() {
        print("eat")
    }
}

class ClassA {
    func CreatStudent() {
        
        let std = Student()
        std.name = "A"
        std.sex = "男"
        std.height = 188.8
        
        std.eat()
        
        var people = std as People
        people.height = 200.0
        
    }
}
