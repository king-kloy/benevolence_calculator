import 'package:benevolence_calculator/src/core/models/delivery_model.dart';
import 'package:benevolence_calculator/src/core/models/payment_model.dart';
import 'package:benevolence_calculator/src/core/service/database_service.dart';

import '../../core/models/customer_model.dart';

class Api {
  DatabaseService databaseService;

  Api() {
    databaseService = DatabaseService();
  }

  saveCustomerDetails(CustomerModel customerModel) async {
    return await databaseService.insertCustomerData(customerModel);
  }

  fetchCustomers() async {
    return await databaseService.getAllCustomers();
  }

  saveCustomerDelivery(DeliveryModel deliveryModel) async {
    return await databaseService.insertDeliveryData(deliveryModel);
  }

  saveCustomerPayment(PaymentModel paymentModel) async {
    return await databaseService.insertPaymentData(paymentModel);
  }

  fetchRecentDeliveries() async {
    List<DeliveryModel> deliveries = await databaseService
        .getAllDeliveries()
        .then((deliveries) => deliveries);

    List<Map<String, dynamic>> customersWithDeliveries = [];

    for (var delivery in deliveries) {
      // get customer
      var customer = await databaseService
          .getCustomer(delivery.customerId)
          .then((customer) => customer);

      // add to list of customers and deliveries
      customersWithDeliveries.add({'customer': customer, 'delivery': delivery});
    }

    return List<Map<String, dynamic>>.from(customersWithDeliveries.reversed);
  }

  fetchRecordSummary(int customerId) async {
    List<DeliveryModel> allDeliveries =
        await databaseService.getAllDeliveriesByCustomerId(customerId);

    double sumOfDeleries = 0.00;
    for (var delivery in allDeliveries) {
      sumOfDeleries += double.parse(delivery.totalPrice);
    }

    List<PaymentModel> allPayments =
        await databaseService.getAllPaymentsByCustomerId(customerId);

    double sumOfPayments = 0.00;
    for (var payment in allPayments) {
      sumOfPayments += double.parse(payment.amount);
    }

    double remainingBalance = sumOfDeleries - sumOfPayments;

    return {
      "deliveries": sumOfDeleries,
      "payments": sumOfPayments,
      "balance": remainingBalance
    };
  }
}
