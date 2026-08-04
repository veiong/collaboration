package VehicleModel {

    attribute def Voltage;
    attribute def VehicleCommand;
    attribute def VehicleSpeed;

    port def PowerPort {
        in voltage : Voltage;
    }

    port def CommandPort {
        in command : VehicleCommand;
    }

    port def MotionPort {
        out speed : VehicleSpeed;
    }

    part def Battery {
        port power : PowerPort;
    }

    part def TractionMotor {
        port command : CommandPort;
        port motion : MotionPort;
    }

    part def ElectricVehicle {
        part battery : Battery;
        part tractionMotor : TractionMotor;
    }

    part vehicle : ElectricVehicle;
}
