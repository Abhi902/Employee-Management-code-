import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:flutter/material.dart';

class CommonFormProvider with ChangeNotifier {
  List<CommonFormModel> _formObjects = []; // List to hold form objects

  List<CommonFormModel> get formObjects => _formObjects;

  // Method to add a new form object
  void addFormObject(CommonFormModel newObject) {
    _formObjects.add(newObject);
    notifyListeners();
  }

  // Method to find a form object by name
  CommonFormModel? findFormObjectByName(String name) {
    return _formObjects.firstWhere(
      (obj) => obj.name == name,
      orElse: () => CommonFormModel(
        name: '',
        photo: null,
        category: '',
        reference: '',
        rate: '',
        attendance: '',
        amount: '',
        advance: '',
        kharcha: '',
        autoRent: '',
      ),
    );
  }

  // Method to update a form object
  void updateFormObject(CommonFormModel updatedObject) {
    final index =
        _formObjects.indexWhere((obj) => obj.name == updatedObject.name);
    if (index != -1) {
      _formObjects[index] = updatedObject;
      notifyListeners();
    }
  }

  // Method to delete a form object by index
  void deleteFormObjectByIndex(int index) {
    if (index >= 0 && index < _formObjects.length) {
      _formObjects.removeAt(index);
      notifyListeners();
    }
  }
}
