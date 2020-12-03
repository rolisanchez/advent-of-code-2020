import Foundation

// Use Hash Table Data Structure to find sum

let filepath = "./input.txt"


do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var hashTable =  [Int:Int?]()
        
        for line in lines {
            guard !line.isEmpty else { continue }

            let lineInt = Int(line.trimmingCharacters(in: .whitespacesAndNewlines))!

            hashTable[lineInt] = 0

        }

        print("Finished inserting in hash table")

        let target = 2020
            
        var val1: Int!
        var val2: Int!

        for val in hashTable.keys {
            let y = target - val
            if hashTable.keys.contains(y) {
                val1 = val
                val2 = y
                break
            }
        }

        print("val1: ", val1)
        print("val2: ", val2)
        
        print("product: ", (val1*val2))
    }
    else {
        fatalError("Could not open file")
    }
}