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
            var val3: Int!

            for key1 in hashTable.keys {
                for key2 in hashTable.keys {
                    if key1 == key2 {
                        continue
                    }
                    let sumVal = key1 + key2
                    let y = target - sumVal
                    if hashTable.keys.contains(y) {
                        val1 = key1
                        val2 = key2
                        val3 = y
                        break
                    }
                }
            }

            print("val1: ", val1)
            print("val2: ", val2)
            print("val3: ", val3)
            
            print("product: ", (val1*val2*val3))
    }
    else {
        fatalError("Could not open file")
    }
}