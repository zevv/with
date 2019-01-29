
Simple macro to replace the deprecated ``{.with.}`` pragma in Nim. This macro
looks up all identifiers in a code block to see if they are known field names
for the given object or tuple. If a match is found, the identifier is replaced
by a dot expression ``obj.field``.

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
qualified dot notation to access the original member:

```nim
var foo = (first: 1, second: "two")
with foo:
  doAssert first == 1 
  let first = "dragons"
  doAssert first == "dragons" 
  doAssert foo.first == 1
```
