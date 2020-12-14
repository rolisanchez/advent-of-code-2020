import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

extension Int {
  func mod(_ other: Int) -> Int {
    guard other != 0 else { return 0 }
    let m = self % other
    return m < 0 ? m + other : m
  }
}

// Knuth's modular inverse
func modInv(value: Int, modulus: Int) -> Int? {
  var inv = 1, gcd = value, v1 = 0, v3 = modulus
  var even = true
  while v3 != 0 {
    (inv, v1, gcd, v3) = (v1, inv + gcd / v3 * v1, v3, gcd % v3)
    even.toggle()
  }
  if gcd != 1 { return nil }
  return even ? inv : modulus - inv
}

func chineseRemainder(_ mas: [(Int, Int)]) -> Int {
  let mis = mas.map(\.0), m = mis.reduce(1, *)
  let ais = mas.map(\.1)
  let ws = mis.map { mi -> Int in
    let zi = m / mi
    guard let yi = modInv(value: zi, modulus: mi) else { fatalError("\(zi)^-1 mod \(mi) does not exist!") }
    return (yi * zi) % m
  }
  return zip(ws, ais).reduce(0, { ($0 + ($1.0 * $1.1)) % m })
}

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        let busIDs: [(Int, Int)] =
            zip(lines[1].components(separatedBy: ","), 0...)
            .compactMap {
                guard let i = Int($0) else { return nil }
                return (i, $1) 
            }
            .map { (m, v: Int) in (m, (-v).mod(m)) }
        // print("busIDs: ", busIDs)

        let result = chineseRemainder(busIDs)
        print("Result: ", result)
        // let busesWithNil = lines[1].components(separatedBy: ",").map{Int($0)}

        // Preprocess buses to get each needed offset
        // var busIndexes = [Int:Int]()
        // for (index, busNil) in busesWithNil.enumerated() {
        //     if let bus = busNil {
        //         busIndexes[bus] = index
        //     }
        // }

        // var busNotFound = true
        // var currentTimeStamp = 100000000000000
        // // > 100000000000000

        // while busNotFound {
        //     var testBus = true
        //     for (bus, timeOffset) in busIndexes {
        //         if (currentTimeStamp + timeOffset) % bus != 0 {
        //             testBus = false
        //             break
        //         }
        //     }
        //     if testBus {
        //         busNotFound = false
        //     }
        //     if busNotFound {
        //         currentTimeStamp += 1
        //     }
        // }

        // print("Result: ", currentTimeStamp)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}