
import macros
import sets


macro with*(obj: typed, cs: untyped): untyped =

  # extract list of field names from the given object

  var typ = obj.getTypeImpl
  if typ.kind == nnkRefTy:
    typ = typ[0].getTypeImpl

  expectKind(typ, nnkObjectTy)
  expectKind(typ[2], nnkRecList)
  var fields = initSet[string]()
  for id in typ[2]:
    fields.incl id[0].strVal

  # recurse through code block AST and replace all identifiers
  # which are a field of the given object by a dotexpr obj.field

  proc aux(obj: NimNode, n: NimNode): NimNode =
    if n.kind == nnkIdent and  n.strVal in fields:
      result = newDotExpr(obj, n)
    else:
      result = copyNimNode(n)
      for nc in n:
        result.add aux(obj, nc)

  result = aux(obj, cs)

# vi: ft=nim et ts=2 sw=2

