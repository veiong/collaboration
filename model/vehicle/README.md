# Vehicle Structure Slice

This slice defines a deliberately small system structure:

```text
vehicle : ElectricVehicle
|- battery : Battery
`- tractionMotor : TractionMotor
```

The ports are the first collaboration boundary. Requirements and verification artifacts should reference the typed parts and ports rather than duplicating names in prose.

The file is a teaching artifact based on SysML v2 textual notation. Validate it with the target SysML v2 implementation before using it for engineering decisions.
