package VehicleRequirements {

    private import VehicleModel::*;

    requirement def VehicleMassRequirement {
        subject vehicle : ElectricVehicle;
        attribute massLimit : Real;
    }

    requirement def MotionCommandRequirement {
        subject motor : TractionMotor;
    }

    requirement def BatteryIsolationRequirement {
        subject battery : Battery;
        attribute isolationVoltage : Real;
    }

    part requirementsContext {
        ref vehicle : ElectricVehicle;

        satisfy requirement vehicleMass : VehicleMassRequirement by vehicle;
        satisfy requirement motionCommand : MotionCommandRequirement by vehicle.tractionMotor;
        satisfy requirement batteryIsolation : BatteryIsolationRequirement by vehicle.battery;
    }
}
