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

block:
  
  var foo = Foo(first: 1, second: "two", third: 3.0)
  
  with foo:
    doAssert first == 1
    doAssert second == "two"
    doAssert third == 3.0
  
block:
  
  var foo = Foo(first: 1, second: "two", third: 3.0)
  var bar = Bar(alpha: 10, beta: "twenty")
  
  with foo:
    doAssert first == 1
    doAssert second == "two"
    with bar:
      doAssert third == 3.0
      doAssert alpha == 10
      doAssert beta == "twenty"
  
block:
 
  var sub = Sub(foo: Foo(first: 1))

  with sub:
    doAssert foo.first == 1
