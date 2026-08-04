# Vehicle Traceability Matrix

| Requirement | Satisfied by | Verified by | Review owner |
| --- | --- | --- | --- |
| `VehicleMassRequirement` | `ElectricVehicle` | `VehicleMassVerification` | System architecture |
| `MotionCommandRequirement` | `TractionMotor` | `MotionCommandVerification` | Controls |

## Pull Request review order

1. Confirm the requirement expresses an externally meaningful need.
2. Confirm the satisfaction target exists in `vehicle.sysml`.
3. Confirm the verification case has an observable pass/fail objective.
4. Confirm renamed model elements update this matrix in the same PR.

This matrix is a review aid. The SysML v2 relationships in the model remain the authoritative trace links once the model passes tool validation.
