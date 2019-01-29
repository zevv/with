
import macros
import sets


macro with*(obj: typed, cs: untyped): untyped =

  var fields: seq[NimNode]

  # Get the type of the object, de-ref if needed

  var typ = obj.getTypeImpl
  if typ.kind == nnkRefTy:
    typ = typ[0].getTypeImpl

  # Extract fields from object or tuple

  if typ.kind == nnkObjectTy:
    for id in typ[2]:
      fields.add id[0]
  elif typ.kind == nnkTupleTy:
    for id in typ:
      fields.add id[0]
  else:
    error "Expected object or tuple"

  # Helper function for recursion

  proc aux(obj: NimNode, n: NimNode): NimNode =

    # 'const, 'let' or 'var' shadows variables by removing them
    # from the fields list

    if n.kind in {nnkConstSection,nnkLetSection,nnkVarSection}:
      for nid in n:
        var delIdx = -1
        for i, f in fields.pairs:
          if eqIdent(f, nid[0]): delIdx = i
        if delIdx != -1: fields.del delIdx

    # Replace with dotExpr if identifier found in fields list

    if n.kind == nnkIdent:
      for f in fields:
        if eqIdent(f, n):
          return newDotExpr(obj, n)

    # Recurse through all children

    result = copyNimNode(n)
    for i, nc in n.pairs:
      if n.kind == nnkDotExpr and i != 0:
        result.add nc
      else:
        result.add aux(obj, nc)

  result = aux(obj, cs)

# vi: ft=nim et ts=2 sw=2

