// import 'package:flutter/material.dart';
// import 'package:sqlite/sqflite/sql_helper2.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List<Map<String, dynamic>> _borrowerProfile = [];
//   final TextEditingController _borrowerName = TextEditingController();
//   final TextEditingController _LoanAmount = TextEditingController();
//   final TextEditingController _Monthly_Payment = TextEditingController();
//   final TextEditingController _TotalRepayment_amount = TextEditingController();

//   bool _isloading = true;

//   void _refreshBorrowerProfile() async {
//     final data = await SQLHelper.getItems();
//     setState(() {
//       _borrowerProfile = data;
//       _isloading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshBorrowerProfile();
//     print(".. number of borrwer ${_borrowerProfile}");
//   }

//   Future<void> _addItem() async {
//     try {
//       int loanAmount = int.parse(_LoanAmount.text);
//       int monthlyPayment = int.parse(_Monthly_Payment.text);
//       int totalRepaymentAmount = int.parse(_TotalRepayment_amount.text);

//       await SQLHelper.createItem(
//           _borrowerName.text, loanAmount, monthlyPayment, totalRepaymentAmount);
//       _refreshBorrowerProfile();
//     } catch (e) {
//       // Handle parsing error or other exceptions
//       print("Error: $e");
//     }
//   }

//   void _showForm(int? id) async {
//     if (id != null) {
//       final borrower_list =
//           _borrowerProfile.firstWhere((element) => element['id'] == id);
//       _borrowerName.text = borrower_list['Borrower Name :'];
//       _LoanAmount.text = borrower_list['Loan Amount'].toString() ?? '';
//       _Monthly_Payment.text = borrower_list['Monthly Payment'].toString() ?? '';
//       _TotalRepayment_amount.text =
//           borrower_list['Total Repayment'].toString() ?? '';
//     }

//     showModalBottomSheet(
//       context: context,
//       elevation: 5,
//       isScrollControlled: true,
//       builder: (_) => Container(
//         padding: EdgeInsets.only(
//             top: 15,
//             left: 15,
//             right: 15,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 60),
//         child: Column(
//           children: [
//             TextField(
//               controller: _borrowerName,
//               decoration: const InputDecoration(hintText: 'Borrower Name'),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: _LoanAmount,
//               decoration: const InputDecoration(hintText: 'loan Amount'),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: _Monthly_Payment,
//               decoration: const InputDecoration(hintText: 'Monthly Payment'),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             TextField(
//               controller: _TotalRepayment_amount,
//               decoration:
//                   const InputDecoration(hintText: 'Total amount with interest'),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   if (id == null) {
//                     await _addItem();
//                   }
//                   // if (id !=null){
//                   //   //await _updateItem
//                   // }

//                   _borrowerName.text = '';
//                   _LoanAmount.text = '';
//                   _Monthly_Payment.text = '';
//                   _TotalRepayment_amount.text = '';

//                   Navigator.of(context).pop();
//                 },
//                 child: Text('submit'))
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SLQ'),
//       ),
//       body: ListView.builder(
//         itemCount: _borrowerProfile.length,
//         itemBuilder: (context, index) => Card(
//           color: Colors.orange[200],
//           margin: const EdgeInsets.all(15),
//           child: ListTile(
//             title: Text(_borrowerProfile[index]['borrower']),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                     'Borrow Amount: ${_borrowerProfile[index]['borrow_amount']}'),
//                 Text(
//                     'Monthly Payment: ${_borrowerProfile[index]['monthly_payment']}'),
//                 Text(
//                     'Total Repayment Amount: ${_borrowerProfile[index]['total_repayment_amount']}'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showForm(null),
//       ),
//     );
//   }
// }
