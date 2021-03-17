import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_car_expense/models/expense_model.dart';
import 'package:flutter/material.dart';
//import 'dart:html';

class FireStoreService {
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalDatewiseIncome = 0.0;
  double totalDatewiseExpense = 0.0;
  String uid = FirebaseAuth.instance.currentUser?.uid;

  //FireStoreService({this.uid});
  FirebaseFirestore _db = FirebaseFirestore.instance;
  // CollectionReference collectionReference =
  //     FirebaseFirestore.instance.collection('expense');

  Future<void> saveExpense(ExpenseModel expenseModel) {
    print('$uid');
    return _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .doc(expenseModel.expenseId)
        //.doc(uid)
        .set(expenseModel.toMap());
    // collectionReference.add(expenseModel.toMap());
    // ignore: dead_code
  }

  Stream<List<ExpenseModel>> getExpense() {
    print('User ID: $uid');
    return _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ExpenseModel.fromFirestore(document.data()))
            .toList());
  }

  Stream<List<ExpenseModel>> getDateWiseExpense(
      DateTime startDate, DateTime endDate) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .orderBy('expenseDate', descending: true)
        .where('expenseDate', isGreaterThan: startDate)
        .where('expenseDate', isLessThanOrEqualTo: endDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ExpenseModel.fromFirestore(document.data()))
            .toList());
  }

  Future<void> removeExpense(String expenseId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .doc(expenseId)
        .delete();
  }

  Future getTotalIncome() async {
    var temp = await _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .where('expenseType', isEqualTo: 'Income')
        .get();

    temp.docs.forEach((doc) => totalIncome += doc.data()['expenseAmount']);

    print('TotalIncome:$totalIncome');
    return totalIncome;
  }

  // Future getDatewiseTotalIncome(DateTime startDate, DateTime endDate) async {
  //   var temp = await _db
  //       .collection('users')
  //       .doc(uid)
  //       .collection('expense')
  //       .where('expenseType', isEqualTo: 'Income')
  //       .where('expenseDate', isGreaterThan: startDate)
  //       .where('expenseDate', isLessThanOrEqualTo: endDate)
  //       .get();

  //   temp.docs
  //       .forEach((doc) => totalDatewiseIncome += doc.data()['expenseAmount']);

  //   print('TotalIncome:$totalDatewiseIncome');
  //   return totalDatewiseIncome;
  // }

  // Future getDatewiseTotalExpense(DateTime startDate, DateTime endDate) async {
  //   var temp = await _db
  //       .collection('users')
  //       .doc(uid)
  //       .collection('expense')
  //       .where('expenseType', isEqualTo: 'Income')
  //       .where('expenseDate', isGreaterThan: startDate)
  //       .where('expenseDate', isLessThanOrEqualTo: endDate)
  //       .get();

  //   temp.docs
  //       .forEach((doc) => totalDatewiseExpense += doc.data()['expenseAmount']);

  //   print('TotalIncome:$totalDatewiseIncome');
  //   return totalDatewiseExpense;
  // }

  Future getTotalExpense() async {
    var temp = await _db
        .collection('users')
        .doc(uid)
        .collection('expense')
        .where('expenseType', isEqualTo: 'Expense')
        .get();

    temp.docs.forEach((doc) => totalExpense += doc.data()['expenseAmount']);

    print('TotalExpense:$totalExpense');
    return totalExpense;
  }
}
