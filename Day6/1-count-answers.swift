import Foundation

let filepath = "./input.txt"
// let filepath = "./testgroups.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
    let groups = contents.components(separatedBy: "\n\n")

    var sumCount = 0
    for group in groups {
        var thisGroupSet = Set<Character>()
        let lines = group.components(separatedBy: "\n")
        for line in lines {
            for char in line {
                thisGroupSet.insert(char)
            }
        }
        
        sumCount += thisGroupSet.count
    }
    print("sumCount: ", sumCount)
    } else { 
        fatalError("Could not open file")
    }
}