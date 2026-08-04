package VehicleVerification {

    private import VehicleModel::*;
    private import VehicleRequirements::*;

    verification def VehicleMassVerification {
        subject vehicle : ElectricVehicle;
        objective massRequirement : VehicleMassRequirement;
    }

    verification def MotionCommandVerification {
        subject motor : TractionMotor;
        objective commandRequirement : MotionCommandRequirement;
    }

    verification vehicleMassTest : VehicleMassVerification;
    verification motionCommandTest : MotionCommandVerification;
}
