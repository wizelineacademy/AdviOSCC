//: Playground - noun: a place where people can play


import Foundation




//: # Mutability

/*:
 # Structs and Classes
 
 In Swift, we can choose from multiple options to store structured data: structs,
 enums, classes. Most of the public types in Swift's standard library are defined as structs, with enums and classes making up a much smaller percentage. In Swift 3, many of the classes in Foundation now
 have struct counterparts specifically built.
 
 - Structs (and enums) are *value types*, whereas classes are *reference
 types*. When designing with structs, we can ask the compiler to enforce
 immutability. With classes, we have to enforce it ourselves.
 
 - How memory is managed differs. Structs can be held and accessed directly,
 whereas class instances are always accessed indirectly through their
 references. Structs aren't referenced but instead copied. Structs have a
 single owner, whereas classes can have many owners.
 
 - With classes, we can use inheritance to share code. With structs (and
 enums), inheritance isn't possible. Instead, to share code using structs and
 enums, we need to use different techniques, such as composition, generics,
 and protocol extensions.
 
 In recent years, mutability got a bad reputation. It's named as a major cause of
 bugs, and most experts recommend you work with immutable objects where possible.
 
 To see how this works, let's start by showing some of the problems with
 mutation. In Foundation, there are two classes for arrays: `NSArray`, and its
 subclass, `NSMutableArray`. We can write the following (crashing) program using
 `NSMutableArray`:
 
 
 ``` swift-example
 let mutableArray: NSMutableArray = [1,2,3]
 for _ in mutableArray {
 mutableArray.removeLastObject()
 }
 ```
 
 You're not allowed to mutate an `NSMutableArray` while you're iterating through
 it, because the iterator works on the original array, and mutating it corrupts
 the iterator's internal state.
 
 */

/*:
 Now let's consider the same example, but using Swift arrays:
 
 */


var mutableArray = [1, 2, 3]
for _ in mutableArray {
    mutableArray.removeLast()
}

/*:
 This example doesn't crash, because the iterator keeps a local, independent copy
 of the array.
 */

let nsmutableArray: NSMutableArray = [1, 2, 3]
let otherArray = mutableArray
nsmutableArray.add(4)
otherArray //[1,2,3,4]

/*:
 This is a very powerful thing, but it's also a great source of bugs.
 */


/*:
 ## Structs
 
 Value types imply that whenever a variable is copied, the value itself — and not
 just a reference to the value — is copied. For example, in almost all
 programming languages, scalar types(Int, Floats, etc) are value types. This means that whenever a
 value is assigned to a new variable, it's copied rather than passed by
 reference:
 
 */

var a = 42
var b = a
b += 1
b
a

struct Size {
    var width: Int
    var height: Int
}

extension Size: CustomStringConvertible {
    var description: String {
        return "(width: \(width), height: \(height))"
    }
}

let size = Size(width: 0, height: 0)

/*:
 Because structs in Swift have value semantics, we can't change any of the
 properties of a struct variable that's defined using `let`. For example, the
 following code won't work:
 
 ``` swift-example
 size.width = 10 // Error
 ```
 
 Even though we defined `width` within the struct as a `var` property, we can't
 change it, because `size` is defined using `let`. This has some major
 advantages. For example, if you read a line like `let size = ...`, and you know
 that `size` is a struct variable, then you also know that it'll never, ever,
 change. This is a great help when reading through code.
 
 To create a mutable variable, we need to use `var`:
 
 */

var otherSize = Size(width: 0, height: 0)
otherSize.width += 10
otherSize



var thirdSize = size
thirdSize.width += 10
thirdSize
size

/*:
 When you assign a struct to a new variable, Swift automatically makes a copy.
 Even though this sounds very expensive, many of the copies can be optimized away
 by the compiler, and Swift tries hard to make the copies very cheap. In fact,
 many structs in the standard library are implemented using a technique called
 copy-on-write 🐮
 */

var newSize = Size(width: 0, height: 0) {
    didSet {
        print("Size changed: \(newSize)")
    }
}

newSize.width = 10

struct Rectangle {
    var size: Size
}

extension Rectangle: CustomDebugStringConvertible {
    var debugDescription: String {
        return "\((size.width, size.height))"
    }
}

extension Rectangle {
    init(width: Int, height: Int) {
        size = Size(width: width, height: height)
    }
}

var screen = Rectangle(width: 320, height: 480) {
    didSet {
        print("Screen changed: \(screen)")
    }
}

/*:
 Maybe somewhat surprisingly, even if we change something deep inside the struct,
 the following will get triggered:
 
 */

screen.size.width = 10


/*:
 Understanding why this works is key to understanding value types. Mutating a
 struct variable is semantically the same as assigning a new value to it. When we
 mutate something deep inside the struct, it still means we're mutating the
 struct, so `didSet` still needs to get triggered.
 
 Although we semantically replace the entire struct with a new one, the compiler
 can still mutate the value in place; since the struct has no other owner, it
 doesn't actually need to make a copy. With copy-on-write structs, this works differently.
 
 Since arrays are structs, this naturally works with them, too. If we define an
 array containing other value types, we can modify one of the properties of an
 element in the array and still get a `didSet` trigger:
 
 */

var screens = [Rectangle(width: 320, height: 480)] {
    didSet {
        print("Array changed")
    }
}
screens[0].size.width += 100

/*:
 The `didSet` trigger wouldn't fire if `Rectangle` were a class, because in that
 case, the reference the array stores doesn't change — only the object it's
 referring to does.
 
 */


/*:
 ## Copy-On-Write
 
 */

struct D {
    let data: NSMutableString
}

let d = D(data: NSMutableString(string: "Hello"))
let dCopy = d
dCopy.data.append(" World!")
d.data



/*:
 
 In the Swift standard library, collections like `Array`, `Dictionary`, and `Set`
 are implemented using a technique called *copy-on-write*. Let's say we have an
 array of integers:
 
 */





var x = [1,2,3]
var y = x

/*:
 If we create a new variable, `y`, and assign the value of `x` to it, a copy gets
 made, and both `x` and `y` now contain independent structs. Internally, each of
 these `Array` structs contains a reference to some memory. This memory is where
 the elements of the array are stored, and it's located on the heap. At this
 point, the references of both arrays point to the same location in memory — the
 arrays are sharing this part of their storage. However, the moment we mutate
 `x`, the shared reference gets detected, and the memory is copied. This means we
 can mutate both variables independently, yet the (expensive) copy of the
 elements only happens when it has to — once we mutate one of the variables:
 
 */

x.append(5)
y.removeLast()
x
y

/*:
 ### Copy-On-Write (The Expensive Way)
 
 To implement copy-on-write, we can make `_data` a private property of the
 struct. Instead of mutating `_data` directly, we access it through a computed
 property, `_dataForWriting`. This computed property always makes a copy and
 returns it:
 
 */

struct MyString {
    fileprivate var _data: NSMutableString
    var _dataForWriting: NSMutableString {
        mutating get {
            _data = _data.mutableCopy() as! NSMutableString
            return _data
        }
    }
    init(_ data: NSString) {
        self._data = data.mutableCopy() as! NSMutableString
    }
}
//#-end-editable-code

//#-hidden-code
extension MyString: CustomDebugStringConvertible {
    var debugDescription: String {
        return _data.debugDescription
    }
}

extension MyString {
    mutating func append(_ other: String) {
        _dataForWriting.append(other)
    }
}


let d2 = MyString(NSMutableString(string: "Hello"))
var d2Copy = d2
d2Copy.append(" World!")
d2

/*:
 This strategy works, but it's not very efficient if we mutate the same variable
 multiple times. For example, consider the following example:
 
 */

var buffer = MyString(NSMutableString(string: "Hello"))
for _ in 0..<5 {
    buffer.append("")
}

/*:
 Each time we call `append`, the underlying `_data` object gets copied. Because
 we're not sharing the `buffer` variable, it'd have been a lot more efficient to
 mutate it in place.
 
 */

final class Box<A> {
    var unbox: A
    init(_ value: A) { self.unbox = value }
}

var s = Box(NSMutableString(string: "Hello"))
isKnownUniquelyReferenced(&s)

var ys = s
isKnownUniquelyReferenced(&s)

/*:
 This also works when the references are inside a struct, instead of just global
 variables. Using this knowledge, we can now write a variant of `MyData`, which
 checks whether `_data` is uniquely referenced before mutating it. We also add a
 `print` statement to quickly see during debugging how often we make a copy:
 
 */

struct MyData2 {
    fileprivate var _data: Box<NSMutableString>
    var _dataForWriting: NSMutableString {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {
                _data = Box(_data.unbox.mutableCopy() as! NSMutableString)
                print("Making a copy")
            }
            return _data.unbox
        }
    }
    init(_ data: NSString) {
        self._data = Box(data.mutableCopy() as! NSMutableString)
    }
}

extension MyData2: CustomDebugStringConvertible {
    var debugDescription: String {
        return _data.unbox.debugDescription
    }
}

extension MyData2 {
    mutating func append(_ other: String) {
        _dataForWriting.append(other)
    }
}

var empty = MyData2(NSString(string: ""))
var emptyCopy = empty
for _ in 0..<5 {
    empty.append("Hi")
}
empty._data.unbox
emptyCopy._data.unbox

/*:
 If we run the code above, we can see that our debug statement only gets printed
 once: when we call `append` for the first time. In subsequent iterations, the
 uniqueness is detected and no copy gets made.
 
 This technique allows you to create custom structs that are value types while
 still being just as efficient as you would be working with objects or pointers.
 As a user of the struct, you don't need to worry about copying these structs
 manually — the implementation will take care of it for you. Because
 copy-on-write is combined with optimizations done by the compiler, many
 unnecessary copy operations can be removed.
 
 */




