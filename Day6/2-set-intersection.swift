import Foundation

let filepath = "./input.txt"
// let filepath = "./testgroups.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
    let groups = contents.components(separatedBy: "\n\n")

    var sumCount = 0
    for group in groups {
        let lines = group.components(separatedBy: "\n")
        var thisGroupSets = [Set<Character>]()
        for line in lines {
            var personSet = Set<Character>()
            for char in line {
                personSet.insert(char)
            }
            thisGroupSets.append(personSet)
        }
        
        let intersectionSet = thisGroupSets[1..<thisGroupSets.count].reduce(thisGroupSets[0]) { $0.intersection($1) }
        
        sumCount += intersectionSet.count
    }
    print("sumCount: ", sumCount)
    } else { 
        fatalError("Could not open file")
    }
}