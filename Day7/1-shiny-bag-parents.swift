import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        print("Processing rules in lines...")

        // "bright white bag": ["light red bag"]
        // Means that one possible parent for bright white bag is light red bag
        var rulesDict = [String:Set<String>]()

        for line in lines {

            let lineComponents = line.components(separatedBy: "contain ")

            let containerComponents = lineComponents[0].components(separatedBy: " ")
            let parent = containerComponents[0] + " " + containerComponents[1]

            let childComponents = lineComponents[1].components(separatedBy: ", ")

            for childComponent in childComponents {
                let childElements = childComponent.components(separatedBy: " ")
                if childElements[0] == "no" {
                    continue
                }

                let childColor = childElements[1] + " " +  childElements[2]
                if rulesDict[childColor] == nil {
                    rulesDict[childColor] = Set<String>()
                } 
                
                rulesDict[childColor]?.insert(parent)
            }
            
        }

        var needToCheck = rulesDict["shiny gold"]!
        var possibleContainers = Set<String>()

        while needToCheck.count > 0 {
            for elem in needToCheck {

                possibleContainers.insert(elem)
                needToCheck.remove(elem)

                if let elemParents = rulesDict[elem] {
                    for parent in elemParents {
                        needToCheck.insert(parent)
                    }
                }
            }

        }

        print("Result: ", possibleContainers.count)

    } else { 
        fatalError("Could not open file")
    }
}