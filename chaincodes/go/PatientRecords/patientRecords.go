/*
blockchain-assignment project's chaincode

Problem Statement:
In healthcare, a patient has their health record fragmented across multiple
locations e.g. labs, hospital etc. In a decentralized world, how can you make
sure that these records can be stored on blockchain and can help patients to
access them anywhere they want. & obviously, as medical records are a very
personal entity, we want you to write the smart contract that is going to secure
a single piece of data so that only patient can access it.

*/

package main

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/lib/cid"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type VitalRecord struct {
	RecordingTime string `json:"recordingTime"`
	BloodPressure string `json:"bloodPressure"`
	BloodGlucose  string `json:"bloodGlucose"`
}

type PatientRecord struct {
	ObjectType            string      `json:"docType"`
	PatientID             string      `json:"patientID"`
	ActiveProblems        []string    `json:"activeProblems"`
	ActiveMedications     []string    `json:"activeMedications"`
	HistoricalProblems    []string    `json:"historicalProblems"`
	HistoricalMedications []string    `json:"historical Medications"`
	Vitals                VitalRecord `json:"vitalsRecord"`
	DoctorInCharge        string      `json:"doctor"`
	Event                 string      `json:"event"`
}

type SimpleChainCode struct {
}

func (t *SimpleChainCode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return shim.Success(nil)
}

func (t *SimpleChainCode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {

	//parse the function name and the rest of the arguments
	function, args := stub.GetFunctionAndParameters()

	//pass the control to the function in the input
	switch function {
	case "createRecord":
		// A doctor creates a patient record
		return t.createRecord(stub, args)
	case "addMedication":
		// Doctor suggests a new medication
		return t.addMedication(stub, args)
	case "updateRecordforLab":
		// Lab report is added to the patient record
		return t.addLabReport(stub, args)
	case "queryRecord":
		// Query using email id
		return t.queryRecord(stub, args)
	default:
		return shim.Error("Not a valid function")
	}
}

func main() {
	err := shim.Start(new(SimpleChainCode))
	if err != nil {
		fmt.Printf("Error starting Simple Chaincode: %s", err)
	}
}

func (t *SimpleChainCode) createRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// email ID, Active Problem csv, Active med csv, hist problem csv, hist med
	// csv, vitals csv in the format (Blood Pressure, Blood Glucose)
	if len(args) != 6 {
		return shim.Error("Wrong number of arguments, expecting 6")
	}

	patientID := args[0]
	activeProblemString := args[1]
	activeMedString := args[2]
	histProblemString := args[3]
	histMedString := args[4]
	vitalsString := args[5]

	if len(patientID) == 0 {
		return shim.Error("patient ID is a mandatory field")
	}

	recordBytes, err := stub.GetState(patientID)
	if err != nil {
		return shim.Error(err.Error())
	} else if recordBytes != nil {
		return shim.Error("Record is already existing in the ledger, cannot create duplicate")
	}

	if len(vitalsString) == 0 {
		return shim.Error("Please send at least the patient vitals")
	}

	var (
		activeProblems       []string
		activeMedications    []string
		historicalProblems   []string
		historicalMedication []string
		vitalRecord          VitalRecord
	)

	if len(activeProblemString) != 0 {
		activeProblems = strings.Split(activeProblemString, ",")
	}

	if len(activeMedString) != 0 {
		activeMedications = strings.Split(activeMedString, ",")
	}

	if len(histProblemString) != 0 {
		historicalProblems = strings.Split(histProblemString, ",")
	}

	if len(histMedString) != 0 {
		historicalMedication = strings.Split(histMedString, ",")
	}

	temp := strings.Split(vitalsString, ",")

	vitalRecord.BloodPressure = temp[0]
	vitalRecord.BloodGlucose = temp[1]

	vitalRecord.RecordingTime = time.Now().String()

	id, err := cid.New(stub)

	if err != nil {
		return shim.Error(err.Error())
	}

	err = id.AssertAttributeValue("doctor", "true")

	if err != nil {
		return shim.Error("Error in doctor attribute" + err.Error())
	}

	doctor_email, found, err := id.GetAttributeValue("email")

	if err != nil || !found {
		return shim.Error("Error in email attribute" + err.Error())
	}

	patientRecordObj := &PatientRecord{"patientRecord", patientID, activeProblems, activeMedications,
		historicalProblems, historicalMedication, vitalRecord, doctor_email, "Patient Record Created"}

	//Convert Item object to Bytes. Put state take value input in byte array
	recordBytes, err = json.Marshal(patientRecordObj)
	if err != nil {
		//Marshal() failed
		return shim.Error(err.Error())
	}

	err = stub.PutState(patientID, recordBytes)
	if err != nil {
		//PutState() failed
		return shim.Error(err.Error())
	}

	return shim.Success(recordBytes)
}

func (t *SimpleChainCode) addMedication(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// the doctor can suggest new medication
	return shim.Error("Not Implemented Yet")
}

func (t *SimpleChainCode) addCondition(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// the doctor can add a new medical medication
	return shim.Error("Not Implemented Yet")
}

func (t *SimpleChainCode) removeCondition(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// the doctor can make a medical condition historical
	return shim.Error("Not Implemented Yet")
}

func (t *SimpleChainCode) addLabReport(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	//the lab technician will add a Lab Report to the patient. input emailid, blood pressure and blood glucose.
	if len(args) != 3 {
		return shim.Error("Wrong number of arguments, expecting 3")
	}

	id, err := cid.New(stub)

	invoker_email, found, err := id.GetAttributeValue("email")
	if err != nil || !found {
		return shim.Error("Error in email attribute" + err.Error())
	}

	if id.AssertAttributeValue("lab", "true") != nil && id.AssertAttributeValue("doctor", "true") != nil {
		return shim.Error("Authorization to update records failed. You are not authorized to update Vitals of a patient, " + invoker_email)
	}

	patientID := args[0]
	bloodPressure := args[1]
	bloodGlucose := args[2]

	patientRecordBytes, err := stub.GetState(patientID)
	if err != nil {
		return shim.Error(err.Error())
	} else if patientRecordBytes == nil {
		return shim.Error("Invalid ID: " + patientID)
	}

	var patientRecordObj PatientRecord

	err = json.Unmarshal(patientRecordBytes, &patientRecordObj)
	if err != nil {
		return shim.Error(err.Error())
	}

	patientRecordObj.Vitals.BloodPressure = bloodPressure
	patientRecordObj.Vitals.BloodGlucose = bloodGlucose
	patientRecordObj.Event = "Vitals updated by: " + invoker_email

	//Convert Item object to Bytes. Put state take value input in byte array
	recordBytes, err := json.Marshal(patientRecordObj)
	if err != nil {
		//Marshal() failed
		return shim.Error(err.Error())
	}

	err = stub.PutState(patientID, recordBytes)
	if err != nil {
		//PutState() failed
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChainCode) queryRecord(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	// email id of the patient record to query
	if len(args) != 1 {
		return shim.Error("Wrong number of arguments, expecting 1")
	}

	patientID := args[0]
	authorised := false

	id, err := cid.New(stub)

	invoker_email, ok, err := id.GetAttributeValue("email")
	if err != nil || !ok {
		return shim.Error("Error in email attribute" + err.Error())
	}

	// lab technician cannot view a record
	err = id.AssertAttributeValue("lab", "true")
	if err == nil {
		return shim.Error("Authorization to view records failed. You are not authorized to view a patient's record" + err.Error())
	}
	err = id.AssertAttributeValue("patient", "true")
	if err == nil {
		// is the patient querying his record
		if invoker_email != patientID {
			return shim.Error("Authorization to view records failed. You, " + invoker_email + " are not authorized to view another patient's record")
		} else {
			authorised = true
		}
	}

	patientRecordBytes, err := stub.GetState(patientID)
	if err != nil {
		return shim.Error(err.Error())
	} else if patientRecordBytes == nil {
		return shim.Error("Invalid ID: " + patientID)
	}

	var patientRecordObj PatientRecord

	err = json.Unmarshal(patientRecordBytes, &patientRecordObj)
	if err != nil {
		return shim.Error(err.Error())
	}

	doctor := patientRecordObj.DoctorInCharge

	// is the invoker a doctor
	if authorised == false {
		err = id.AssertAttributeValue("doctor", "true")
		if err != nil {
			return shim.Error("You are not authorized to view a patient's record")
		} else {
			if invoker_email != doctor {
				return shim.Error("You, " + invoker_email + " are not authorized to view the record of another doctor's(" + doctor + ") patient")
			}
		}
	}

	return shim.Success(patientRecordBytes)
}
