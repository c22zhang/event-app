//
//  Extensions.swift
//  EventApp
//
//  Created by Christopher Zhang on 4/22/18.
//  Copyright © 2018 Christopher Zhang. All rights reserved.
//

import Foundation

/*
Handy date to String extension from https://stackoverflow.com/questions/42524651/convert-nsdate-to-string-in-ios-swift
*/
extension Date{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
