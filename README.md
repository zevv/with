
Simple macro to replace the deprecated ``{.with.}`` pragma in Nim. This macro
looks up all identifiers in a code block to see if they are known field names
for the given object. If a match is found, the identifier is replaced by a dot
expression ``obj.field``.

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

