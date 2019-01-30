
`with` is a simple macro to replace the deprecated ``{.with.}`` pragma in Nim.
This macro looks up all identifiers in a code block to see if they are known
field names for the given object or tuple. If a match is found, the identifier
is replaced by a dot expression ``obj.field``.

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


Fields from the object can be shadowed by new declarations. Use the fully
qualified dot notation to access the original member if the field has been
shadowed. Shadowing is only effictive in the scope where the new declaration
was made, outside that scope the original `with` behaviour applies:

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
