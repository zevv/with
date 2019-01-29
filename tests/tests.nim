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

  test "basic object":

    var foo = Foo(first: 1, second: "two", third: 3.0)

    with foo:
      check first == 1
      check second == "two"
      check third == 3.0

  test "basic tuple":

    var foo = (first: 1, second: "two")
    with foo:
      check first == 1
      check second == "two"
  
  test "case insensitive":

    var foo = Foo(first: 1, second: "two", third: 3.0)

    with foo:
      check first == 1
      check fiRSt == 1
      check fi_rst == 1

  test "nested 'with'":

    var foo = Foo(first: 1, second: "two", third: 3.0)
    var bar = Bar(alpha: 10, beta: "twenty")

    with foo:
      check first == 1
      check second == "two"
      with bar:
        check third == 3.0
        check alpha == 10
        check beta == "twenty"

  test "dot expressions":

    var sub = Sub(foo: Foo(first: 1))

    with sub:
      check foo.first == 1

  test "more complex AST":

    var foo = Foo(first: 1, second: "two", third: 3.0)

    with foo:
      proc test() =
        check first == 1
        if true:
          check second == "two"
      test()
      for i in 1..10:
        check third == 3.0

  test "skip dot expressions":

    var foo = Foo(first: 1, second: "two", third: 3.0)

    with foo:
      first = 2
      foo.first = 3

  test "shadowing":

    var foo = (first: 1, second: "two", third: 3.0)

    with foo:

      foo.first = 2
      check first == 2
      check foo.first == 2

      first = 3
      check first == 3
      check foo.first == 3

      # const

      const first = "dragons"
      check first == "dragons"
      check foo.first == 3

      # let

      check second == "two"
      let second = 44
      check second == 44
      check foo.second == "two"

      # var

      check third == 3.0
      var third = 42.0
      check third == 42.0
      check foo.third == 3.0

