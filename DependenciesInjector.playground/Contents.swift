class DependencyKey: Hashable, Equatable {
    private let type: Any.Type
    private let name: String?
    
    init(type: Any.Type, name: String? = nil) {
        self.type = type
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(name)
    }
    
    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type && lhs.name == rhs.name
    }
}

class DependeciesContainer {
    static let shared = DependeciesContainer()
    
    private init() {}
    
    private var dependecies: [DependencyKey : Any] = [:]
    
    func register<T>(type: T.Type, name: String? = nil, service: Any) {
        let dependencyKey = DependencyKey(type: type, name: name)
        dependecies[dependencyKey] = service
    }
    
    func resolve<T>(type: T.Type, name: String? = nil) -> T? {
        let dependencyKey = DependencyKey(type: type, name: name)
        return dependecies[dependencyKey] as? T
    }
}

protocol Animal {
    func isAlive() -> Bool
}

class Cat: Animal {
    func isAlive() -> Bool {
        true
    }
    
    func miaow() -> String {
        return "miaow"
    }
}

class Dog: Animal {
    func isAlive() -> Bool {
        true
    }
    
    func bark() -> String {
        return "wooof"
    }
}

class Tiger: Animal {
    func isAlive() -> Bool {
        true
    }
    
    func roar() -> String {
        return "roar"
    }
}


protocol Person {
    func breath() -> String
}

class SickPerson: Person {
    func breath() -> String {
        return "fiuu"
    }
    
    func cough() -> String {
        return "cough"
    }
}

let dc = DependeciesContainer.shared

// Register using class `Type` Dog
dc.register(type: Dog.self, service: Dog())
let dog = dc.resolve(type: Dog.self)!
print(String(describing: dog))
print(dog.bark())

// Register using protocol `Type` Person
dc.register(type: Person.self, service: SickPerson())
let person = dc.resolve(type: Person.self)!
print(String(describing: person))
print(person.breath())
print((person as! SickPerson).cough())

// Register using protocol `Type` Animal and variations
dc.register(type: Animal.self, name: "Cat", service: Cat())
dc.register(type: Animal.self, name: "Tiger", service: Tiger())
let cat = dc.resolve(type: Animal.self, name: "Cat")!
print(String(describing: cat))
print(cat.isAlive())
print((cat as! Cat).miaow())
let tiger = dc.resolve(type: Animal.self, name: "Tiger")!
print(String(describing: tiger))
print(tiger.isAlive())
print((tiger as! Tiger).roar())

