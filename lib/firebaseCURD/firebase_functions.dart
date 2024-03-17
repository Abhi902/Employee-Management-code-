import 'dart:developer';
import 'dart:io';

import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static Future<void> deleteEmployee(String documentId) async {
    log(documentId);
    try {
      await FirebaseDatabase.instance
          .ref()
          .child('EmployeeData')
          .child(documentId)
          .remove();
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }

  static Stream<List<CommonFormModel>> getAllEmployeesStream() {
    DatabaseReference employeeDataReference =
        FirebaseDatabase.instance.ref().child('EmployeeData');

    return employeeDataReference.onValue.map(
      (event) {
        final employees = <CommonFormModel>[];

        if (event.snapshot.value != null) {
          Map<String, dynamic>? employeesData =
              (event.snapshot.value as Map<Object?, Object?>)
                  .cast<String, dynamic>();

          log("pringing");

          employeesData.forEach((key, value) {
            // Assuming 'Monthly' is another Map inside each employee
            Map<String, dynamic>? monthlyData =
                (value['Monthly'] as Map<Object?, Object?>)
                    ?.cast<String, dynamic>();

            if (monthlyData != null) {
              // Get the keys (months) of monthly entries
              List<String> entryMonths =
                  monthlyData.keys.cast<String>().toList();

              // Sort the keys (months) in descending order
              entryMonths.sort((a, b) => b.compareTo(a));

              // Fetch the data for the current running month
              String currentMonth = DateFormat('MMMM').format(DateTime.now());
              if (entryMonths.isNotEmpty && entryMonths.first == currentMonth) {
                CommonFormModel employee = CommonFormModel.fromJson(
                  Map<String, dynamic>.from(monthlyData[currentMonth]),
                );
                employee.uid = key;
                print('Employee UID: ${employee.uid}');
                employees.add(employee);
              } else {
                CommonFormModel employee = CommonFormModel.fromJson(
                  Map<String, dynamic>.from(monthlyData[entryMonths.first]),
                );
                employee.uid = key;
                print('Employee UID: ${employee.uid}');
                employees.add(employee);
              }
            }
          });
        }

        return employees;
      },
    );
  }

  static Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    // Create an instance of Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch all documents from the "Users" collection
    QuerySnapshot querySnapshot = await firestore.collection('Users').get();

    // Map each document to its data in a List<Map<String, dynamic>>
    List<Map<String, dynamic>> users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return users;
  }

  Future<bool> addEmployee(CommonFormModel employee) async {
    try {
      // Upload photo to Firebase Storage
      String? photoFileName;
      String photoURL = '';
      if (employee.photo != null) {
        photoFileName =
            'employee_photos/${employee.name}_${DateTime.now().millisecondsSinceEpoch}.png';
        firebase_storage.UploadTask task = firebase_storage
            .FirebaseStorage.instance
            .ref(photoFileName)
            .putData(await employee.photo!.readAsBytes());

        await task.whenComplete(() async {
          photoURL = await task.snapshot.ref.getDownloadURL();
        });
        log(photoFileName);
      }

      log("working");

      DatabaseReference employeeDataReference =
          FirebaseDatabase.instance.ref().child('EmployeeData');

      // Push data to the 'EmployeeData' node, which will generate a unique key
      DatabaseReference newEmployeeReference = employeeDataReference.push();

      // Create a new child node (subcollection) under the 'Monthly' node with the current month as the child name
      String currentMonth = DateFormat('MMMM').format(DateTime.now());
      DatabaseReference subcollectionReference =
          newEmployeeReference.child('Monthly').child(currentMonth);
      var managerData = employee.manager
          ?.map((m) => m.map((key, value) => MapEntry(key, value)))
          .toList();

      // Add data to the new subcollection
      await subcollectionReference.set(
        {
          'name': employee.name,
          'photo': photoURL,
          'category': employee.category,
          'reference': employee.reference,
          'rate': employee.rate,
          'attendance': employee.attendance,
          'amount': employee.amount,
          'advance': employee.advance,
          'kharcha': employee.kharcha,
          'autoRent': employee.autoRent,
          'createdAt': ServerValue.timestamp,
          'lastUpdatedPerson': employee.lastUpdatedPerson,
          'photo_location': photoFileName,
          'manager': managerData,
        },
      );

      return true;
    } catch (e) {
      print('Error adding employee: $e');
      return false;
    }
  }

  static Future<String?> getPhotoURL(String photoFileName) async {
    try {
      // Construct the reference to the file in Firebase Storage using the filename
      final ref = firebase_storage.FirebaseStorage.instance.ref(photoFileName);

      // Get the download URL for the file
      final String photoURL = await ref.getDownloadURL();

      return photoURL;
    } catch (e) {
      print('Error fetching photo URL: $e');
      return null;
    }
  }

  static Future<void> updateEmployee(
      {required String documentId,
      String? advance,
      String? kharcha,
      String? autoRent,
      String? amount,
      String? rate,
      String? attendance,
      String? lastUpdatedPerson,
      CommonFormModel? presentEmployee // New field
      }) async {
    try {
      // DateTime nowTime = DateTime.now();

      final now = ServerValue.timestamp;

      // Construct the path to the employee's data
      final DatabaseReference employeeDataReference = FirebaseDatabase.instance
          .ref()
          .child('EmployeeData')
          .child(documentId);

      String? photoURL =
          await getPhotoURL(presentEmployee?.photoLocation as String);

      // Assuming 'Monthly' is another Map inside each employee
      final DatabaseReference monthlyReference =
          employeeDataReference.child('Monthly');

      // Get the current running month

      String currentMonth = DateFormat('MMMM').format(DateTime.now());

      // Construct the path to the employee's data for the current running month
      final DatabaseReference currentMonthReference =
          monthlyReference.child(currentMonth);

      final Map<String, dynamic> updateFields = {};

      if (advance != null) {
        updateFields['advance'] = advance;
        updateFields['lastUpdateAdvance'] = now;
      }

      if (kharcha != null) {
        updateFields['kharcha'] = kharcha;
        updateFields['lastUpdateKharcha'] = now;
      }

      if (autoRent != null) {
        updateFields['autoRent'] = autoRent;
        updateFields['lastUpdateAutoRent'] = now;
      }

      if (rate != null) {
        log("rate updated");
        updateFields['rate'] = rate;
        updateFields['lastUpdateRate'] = now;
      }

      if (attendance != null) {
        updateFields['attendance'] = attendance;
        updateFields['lastUpdateAttendance'] = now;
      }

      updateFields['amount'] = amount;
      updateFields['lastUpdatedPerson'] = lastUpdatedPerson;

      // Check if the current month node already exists
      final DatabaseEvent currentMonthSnapshot =
          await currentMonthReference.once();

      log("current month snapshot ${currentMonthSnapshot.snapshot.exists.toString()}");
      if (currentMonthSnapshot.snapshot.exists) {
        // Update the existing fields under the current month
        await currentMonthReference.update(updateFields);
      } else {
        // Create the current month node if it doesn't exist
        final Map<String, dynamic> updateFields = {};

        updateFields['photo'] = photoURL;
        updateFields['photo_location'] = presentEmployee?.photoLocation;
        updateFields['category'] = presentEmployee!.category;
        updateFields['name'] = presentEmployee.name;
        // updateFields['photo'] = presentEmployee.photo;
        presentEmployee.reference.isNotEmpty
            ? updateFields['reference'] = presentEmployee.reference
            // ignore: unnecessary_statements
            : null;

        if (advance != null) {
          updateFields['advance'] = advance;
        } else {
          updateFields['advance'] = presentEmployee.advance;
        }

        if (kharcha != null) {
          updateFields['kharcha'] = kharcha;
        } else {
          updateFields['kharcha'] = presentEmployee.kharcha;
        }

        if (autoRent != null) {
          updateFields['autoRent'] = autoRent;
        } else {
          updateFields['autoRent'] = presentEmployee.autoRent;
        }

        if (rate != null) {
          updateFields['rate'] = rate;
        } else {
          updateFields['rate'] = presentEmployee.rate;
        }

        updateFields['amount'] = amount;

        if (attendance != null) {
          updateFields['attendance'] = attendance;
        } else {
          updateFields['attendance'] = presentEmployee.attendance;
        }
        updateFields['lastUpdatedPerson'] = lastUpdatedPerson;
        updateFields['lastUpdateAdvance'] = now;
        updateFields['lastUpdateAutoRent'] = now;
        updateFields['lastUpdateKharcha'] = now;
        updateFields['lastUpdateAttendance'] = now;
        updateFields['lastUpdateRate'] = now;
        updateFields["createdAt"] = ServerValue.timestamp;

        // updateFields['category'] = presentEmployee.category;
        await currentMonthReference.set(updateFields);
      }
    } catch (e) {
      print('Error updating employee: $e');
    }
  }
}
