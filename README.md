
> _`with` is fun, but as its own project it should have a splash image like "Inspired by a forbidden(TM) JavaScript feature!"_
> -jrfondren

`with` is a simple macro to replace the deprecated ``{.with.}`` pragma in Nim.
This macro allow you to access fields of an object or tuple without having to
repeatedly type its name. It works by creating tiny templates with the same
name as the field that expand to access to the field in the object.

Example:


```nim
type Foo = ref object
  first: int
  second: string
  third: float

var foo = Foo(first: 1, second: "two", third: 3.0)

with foo:
  echo first
  if true:
    third = float(first)
  echo second
```


``with`` also works with named tuples:

```nim
var foo = (first: 1, second: "two")
with foo:
  first = 3
  second = "six"
```


Fields from the object can be shadowed by new declarations in the scope where
the new declaration is made. The object field can still be accessed by using its
full dot-expression notation:


```nim
var foo = (first: 1, second: "two")
with foo:
  assert first == 1
  if true:
    let first = "dragons"
    assert first == "dragons" 
    assert foo.first == 1
  assert first == 1
  assert foo.first == 1
```


For the brave, ``with`` blocks can be nested, or multiple objects can be passed
in a tuple constructor. Make sure that field names are unique in the nested
objects:

```nim
var foo = (first: 1, second: "two")
var bar = (alpha: 42)

with foo:
  with bar:
    first = alpha

with (foo,bar):
  first = alpha
```
