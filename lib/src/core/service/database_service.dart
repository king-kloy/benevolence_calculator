import 'dart:async';
import 'dart:io' as io;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/customer_model.dart';
import '../models/delivery_model.dart';
import '../models/payment_model.dart';

class DatabaseService {
  static Database _db;
  static const String DB_NAME = 'benevolence_database.db'; // database name
  // CUSTOMER_ID can be used for all tables as a foreign key
  static const String CUSTOMER_ID = 'customerId';

  // Customers Table
  static const String CUSTOMERS_TABLE = 'Customers';
  static const String PROFILE_ID = 'id';
  static const String NAME = 'name';
  static const String IMAGE_PATH = 'imagePath';
  static const String PHONE_NUMBER = 'phoneNumber';
  static const String ADDRESS = 'address';

  // Deliveries Table
  static const String DELIVERIES_TABLE = 'Deliveries';
  static const String DELIVERY_ID = 'id';
  static const String TOTAL_PRICE = 'totalPrice';
  static const String SMALL_BREAD_QTY = 'smallBreadQty';
  static const String BIG_BREAD_QTY = 'bigBreadQty';
  static const String BIGGER_BREAD_QTY = 'biggerBreadQty';
  static const String BIGGEST_BREAD_QTY = 'biggestBreadQty';
  static const String ROUND_BREAD_QTY = 'roundBreadQty';
  static const String DELIVERY_DATE = 'deliveryDate';

  // Payments Table
  static const String PAYMENTS_TABLE = 'Payments';
  static const String PAYMENTS_ID = 'id';
  static const String AMOUNT = 'amount';
  static const String PAYMENT_DATE = 'paymentDate';

  // get database
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  // initialize the database with DB_NAME
  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // creates a database table
  _onCreate(Database db, int version) async {
    // creating various database tables
    await db.execute(
        "CREATE TABLE $CUSTOMERS_TABLE($PROFILE_ID INTEGER PRIMARY KEY, $NAME TEXT, $IMAGE_PATH TEXT, $PHONE_NUMBER TEXT, $ADDRESS TEXT)");
    await db.execute(
        "CREATE TABLE $DELIVERIES_TABLE($DELIVERY_ID INTEGER PRIMARY KEY, $CUSTOMER_ID INTEGER, $TOTAL_PRICE TEXT, $SMALL_BREAD_QTY TEXT, $BIG_BREAD_QTY TEXT, $BIGGER_BREAD_QTY TEXT, $BIGGEST_BREAD_QTY TEXT, $ROUND_BREAD_QTY TEXT, $DELIVERY_DATE TEXT, FOREIGN KEY($CUSTOMER_ID) REFERENCES $CUSTOMERS_TABLE($PROFILE_ID))");
    await db.execute(
        "CREATE TABLE $PAYMENTS_TABLE($PAYMENTS_ID INTEGER PRIMARY KEY, $CUSTOMER_ID INTEGER, $AMOUNT TEXT, $PAYMENT_DATE TEXT, FOREIGN KEY($CUSTOMER_ID) REFERENCES $CUSTOMERS_TABLE($PROFILE_ID))");
    // return db;
  }

  // ---------------------------------------------------------------------------------
  //                      INSERT QUERIES
  // ---------------------------------------------------------------------------------
  // insert data into the CUSTOMERS_TABLE
  Future<CustomerModel> insertCustomerData(CustomerModel customerModel) async {
    var dbClient = await db;
    customerModel.id =
        await dbClient.insert(CUSTOMERS_TABLE, customerModel.toMap());

    return customerModel;

    // another way
    // await dbClient.transaction((txn) async {
    //   var query =
    //       "INSERT INTO $TABLE($NAME) VALUES ('" + customerModel.name + "')";
    //   return await txn.rawInsert(query);
    // });
  }

  // insert data into the DELIVERIES_TABLE
  Future<DeliveryModel> insertDeliveryData(DeliveryModel deliveryModel) async {
    var dbClient = await db;
    deliveryModel.id =
        await dbClient.insert(DELIVERIES_TABLE, deliveryModel.toMap());

    return deliveryModel;
  }

  // insert data into the PAYMENTS_TABLE
  Future<PaymentModel> insertPaymentData(PaymentModel paymentModel) async {
    var dbClient = await db;
    paymentModel.id =
        await dbClient.insert(PAYMENTS_TABLE, paymentModel.toMap());

    return paymentModel;
  }

  // ---------------------------------------------------------------------------------
  //                      FETCH ALL QUERIES
  // ---------------------------------------------------------------------------------
  // get all customers from CUSTOMERS_TABLE
  Future<List<CustomerModel>> getAllCustomers() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(CUSTOMERS_TABLE,
        columns: [PROFILE_ID, NAME, IMAGE_PATH, PHONE_NUMBER, ADDRESS],
        orderBy: "$NAME ASC"); // similar to...
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");

    List<CustomerModel> listOfCustomers = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfCustomers.add(CustomerModel.fromMap(maps[i]));
      }
    }

    return listOfCustomers;
  }

  // get all deliveries from DELIVERIES_TABLE
  Future<List<DeliveryModel>> getAllDeliveries() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(DELIVERIES_TABLE, columns: [
      DELIVERY_ID,
      CUSTOMER_ID,
      TOTAL_PRICE,
      SMALL_BREAD_QTY,
      BIG_BREAD_QTY,
      BIGGER_BREAD_QTY,
      BIGGEST_BREAD_QTY,
      ROUND_BREAD_QTY,
      DELIVERY_DATE,
    ]);

    List<DeliveryModel> listOfDeliveries = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfDeliveries.add(DeliveryModel.fromMap(maps[i]));
      }
    }

    return listOfDeliveries;
  }

  // get delivery by customerId from DELIVERIES_TABLE
  Future<List<DeliveryModel>> getAllDeliveriesByCustomerId(
      int customerId) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(DELIVERIES_TABLE,
        columns: [
          DELIVERY_ID,
          CUSTOMER_ID,
          TOTAL_PRICE,
          SMALL_BREAD_QTY,
          BIG_BREAD_QTY,
          BIGGER_BREAD_QTY,
          BIGGEST_BREAD_QTY,
          ROUND_BREAD_QTY,
          DELIVERY_DATE,
        ],
        where: '$CUSTOMER_ID = ?',
        whereArgs: [customerId]);

    List<DeliveryModel> listOfDeliveries = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfDeliveries.add(DeliveryModel.fromMap(maps[i]));
      }
    }

    return listOfDeliveries;
  }

  // get all payments from PAYMENTS_TABLE
  Future<List<PaymentModel>> getAllPayments() async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(PAYMENTS_TABLE, columns: [
      PAYMENTS_ID,
      CUSTOMER_ID,
      AMOUNT,
      PAYMENT_DATE,
    ]);

    List<PaymentModel> listOfPayments = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfPayments.add(PaymentModel.fromMap(maps[i]));
      }
    }

    return listOfPayments;
  }

  // get payments by customerId from  PAYMENTS_TABLE
  Future<List<PaymentModel>> getAllPaymentsByCustomerId(int customerId) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(PAYMENTS_TABLE,
        columns: [
          PAYMENTS_ID,
          CUSTOMER_ID,
          AMOUNT,
          PAYMENT_DATE,
        ],
        where: '$CUSTOMER_ID = ?',
        whereArgs: [customerId]);

    List<PaymentModel> listOfPayments = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listOfPayments.add(PaymentModel.fromMap(maps[i]));
      }
    }

    return listOfPayments;
  }

  // ---------------------------------------------------------------------------------
  //                      FETCH ONE QUERIES
  // ---------------------------------------------------------------------------------
  // get a customer from CUSTOMERS_TABLE
  Future<CustomerModel> getCustomer(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(CUSTOMERS_TABLE,
        columns: [PROFILE_ID, NAME, IMAGE_PATH, PHONE_NUMBER, ADDRESS],
        where: '$PROFILE_ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return CustomerModel.fromMap(maps.first);
    }

    return null;
  }

  // get a delivery by customer from DELIVERIES_TABLE
  Future<DeliveryModel> getDelivery(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(DELIVERIES_TABLE,
        columns: [
          DELIVERY_ID,
          CUSTOMER_ID,
          TOTAL_PRICE,
          SMALL_BREAD_QTY,
          BIG_BREAD_QTY,
          BIGGER_BREAD_QTY,
          BIGGEST_BREAD_QTY,
          ROUND_BREAD_QTY,
          DELIVERY_DATE,
        ],
        where: '$DELIVERY_ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return DeliveryModel.fromMap(maps.first);
    }

    return null;
  }

  // get a payment by customerPAYMENTS_TABLE
  Future<PaymentModel> getPayment(int id) async {
    var dbClient = await db;

    List<Map> maps = await dbClient.query(PAYMENTS_TABLE,
        columns: [
          PAYMENTS_ID,
          CUSTOMER_ID,
          AMOUNT,
          PAYMENT_DATE,
        ],
        where: '$CUSTOMER_ID = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return PaymentModel.fromMap(maps.first);
    }

    return null;
  }

  // ---------------------------------------------------------------------------------
  //                      DELETE QUERIES
  // ---------------------------------------------------------------------------------
  // delete customer from CUSTOMERS_TABLE
  Future<int> deleteCustomer(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(CUSTOMERS_TABLE, where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // delete delivery from DELIVERIES_TABLE
  Future<int> deleteDelivery(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(DELIVERIES_TABLE, where: '$DELIVERY_ID = ?', whereArgs: [id]);
  }

  // delete payment from PAYMENTS_TABLE
  Future<int> deletePayment(int id) async {
    var dbClient = await db;

    return await dbClient
        .delete(PAYMENTS_TABLE, where: '$PAYMENTS_ID = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------------
  //                      UPDATE QUERIES
  // ---------------------------------------------------------------------------------
  // update customer info
  Future<int> updateCustomer(CustomerModel customerModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(CUSTOMERS_TABLE, customerModel.toMap(),
        where: '$PROFILE_ID = ?', whereArgs: [id]);
  }

  // update delivery
  Future<int> updateDelivery(DeliveryModel deliveryModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(DELIVERIES_TABLE, deliveryModel.toMap(),
        where: '$DELIVERY_ID = ?', whereArgs: [id]);
  }

  // update payment
  Future<int> updatePayment(PaymentModel paymentModel, int id) async {
    var dbClient = await db;

    return await dbClient.update(PAYMENTS_TABLE, paymentModel.toMap(),
        where: '$PAYMENTS_ID = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------------
  //                      FINALLY CLOSE DATABASE
  // ---------------------------------------------------------------------------------
  // close database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
