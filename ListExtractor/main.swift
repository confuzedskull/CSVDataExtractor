//
//  main.swift
//  CSVDataExtractor
//
//  Created by James Nakano on 12/11/15.
//  Copyright © 2015 ConfuzedSkull. All rights reserved.
//

import Foundation
import Cocoa

func input() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    let inputString = NSString(data: inputData, encoding:NSUTF8StringEncoding) as! String
    return inputString.substringToIndex(inputString.endIndex.advancedBy(-1))
}

func output(text: String) {
    print(text)
}

func execute(csvFile: String, column: Int) {
    let fileName = csvFile.substringToIndex(csvFile.endIndex.advancedBy(-4))
    let fileExtension = csvFile.substringFromIndex(csvFile.endIndex.advancedBy(-3))
    if fileExtension == "csv" {
        if let fileData = try? String(contentsOfFile: csvFile) {
            let fileLines = fileData.componentsSeparatedByString("\n")
            var extractedData = String()
            output("Extracting")
            for line in 1...fileLines.count-1 {
                if !fileLines[line].isEmpty{
                    let items = fileLines[line].componentsSeparatedByString(",")
                    extractedData.appendContentsOf(items[column]+"\n")
                }
            }
            output("Done.")
            try? extractedData.writeToFile(fileName+".txt", atomically: true, encoding: NSUTF8StringEncoding)
            output("Wrote to " + fileName + ".txt")
        } else {
            output("Error: File does not exist")
        }
    } else {
        output("Error: Not a .csv file")
    }
}

//Program Start
var csvFile: String? = nil
output("List Extractor by James Nakano")
if Process.arguments.count == 1 {
    output("Please provide a .csv file")
    csvFile = input()
}
output("Which column of data would you like to extract?")
let columnNumber = Int(input())

if csvFile != nil {
    execute(csvFile!, column: columnNumber!)
} else {
    for argument in Process.arguments {
        execute(argument, column: columnNumber!)
    }
}
