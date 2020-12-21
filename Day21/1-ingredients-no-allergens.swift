import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        getIngredientsAndAllergens(lines)
        
        // print("Result: ", result)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func getIngredientsAndAllergens(_ lines: [String]){
    var ingredientsToAllergens = [Set<String>:Set<String>]()
    var allIngredients = Set<String>()
    var allAllergens = Set<String>()

    for line in lines {
        let ingrAllerg = line.components(separatedBy: " (contains ")
        let ingredients: Set<String> = Set(ingrAllerg[0].components(separatedBy: " "))
        let allergens: Set<String> = Set(ingrAllerg[1][0..<ingrAllerg[1].count-1].components(separatedBy: ", "))
        allIngredients = allIngredients.union(ingredients)
        allAllergens = allAllergens.union(allergens)
        // ingredients.forEach{allIngredients.insert($0)}
        // allergens.forEach{allAllergens.insert($0)}
        ingredientsToAllergens[ingredients] = allergens
        // print(ingredients)
        // print(allergens)
        // break
    }

    var ingredientsWithAllergens = Set<String>()
    
    allAllergens.forEach { allergen in
        let sets = ingredientsToAllergens.filter { $0.value.contains(allergen)}.map{ $0.key }
        var returnSet = Set<String>()
        if sets.count > 0 {
            returnSet = returnSet.union(sets[0])
            let rest = sets[1..<sets.count]
            returnSet = rest.reduce(returnSet){ $0.intersection($1)}
        }
        ingredientsWithAllergens = ingredientsWithAllergens.union(returnSet)
        

    }
    
    let safeIngredients: Set<String> = allIngredients.subtracting(ingredientsWithAllergens)
    
    var appearingCount = 0
    ingredientsToAllergens.keys.forEach { ingredients in
        safeIngredients.forEach { safeIngredient in
            if ingredients.contains(safeIngredient){
                appearingCount += 1
            }
        }
    }
    print("Result: ", appearingCount)
}

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}