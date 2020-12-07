import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput2.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        // shiny gold bags contain 2 dark red bags.
        // rulesDict["shiny gold"] = ["dark red": 2]
        var rulesDict = [String:[String:Int]]()

        print("Processing rules in lines...")

        for line in lines {
            let lineComponents = line.components(separatedBy: "contain ")

            let containerComponents = lineComponents[0].components(separatedBy: " ")
            let parent = containerComponents[0] + " " + containerComponents[1]
            
            rulesDict[parent] = [String:Int]()
            
            let childComponents = lineComponents[1].components(separatedBy: ", ")

            for childComponent in childComponents {
                let childElements = childComponent.components(separatedBy: " ")
                if childElements[0] == "no" {
                    continue
                }

                let colorCount = Int(childElements[0])!
                
                let childColor = childElements[1] + " " +  childElements[2]
                
                rulesDict[parent]![childColor] = colorCount
                
            }

        }

        let totalCount = countChildren(dict: rulesDict["shiny gold"]!, rules: rulesDict)
    
        print("Result: ", totalCount)
    } else { 
        fatalError("Could not open file")
    }
}

func countChildren(dict: [String:Int], rules: [String:[String:Int]]) -> Int{
    var count = 0

    for (key, value) in dict {
        count += value
        if let elemChildren = rules[key] {
            count += value*countChildren(dict: elemChildren, rules: rules)
        }
        
    }

    return count
}