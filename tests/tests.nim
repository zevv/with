import unittest
import with
  
type

  Foo = object
    first: int
    second: string
    third: float

  Bar = ref object
    alpha: int
    beta: string

  Sub = object
    foo: Foo

suite "with":

  test "basic":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    
    with foo:
      doAssert first == 1
      doAssert second == "two"
      doAssert third == 3.0
    
  test "nested":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    var bar = Bar(alpha: 10, beta: "twenty")
    
    with foo:
      doAssert first == 1
      doAssert second == "two"
      with bar:
        doAssert third == 3.0
        doAssert alpha == 10
        doAssert beta == "twenty"
    
  test "sub-object":
   
    var sub = Sub(foo: Foo(first: 1))

    with sub:
      doAssert foo.first == 1

  test "proc in AST":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    
    with foo:
      proc test() =
        doAssert first == 1
        doAssert second == "two"
        doAssert third == 3.0
      test()

  test "skip dot expressions":
    
    var foo = Foo(first: 1, second: "two", third: 3.0)
    
    with foo:
      first = 2
      foo.first = 3

  test "tuple":
   
    var foo = (first: 1, second: "two")
    with foo:
      first = 3
      second = "six"

