import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqlite/sqflite/sql_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _borrowerProfile = [];
  final TextEditingController _borrowerName = TextEditingController();
  final TextEditingController _loanAmount = TextEditingController();
  final TextEditingController _monthlyPayment = TextEditingController();
  final TextEditingController _totalRepaymentAmount = TextEditingController();

  bool _isLoading = true;

  void _refreshBorrowerProfile() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _borrowerProfile = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBorrowerProfile();
  }

  Future<void> _addItem() async {
    try {
      int loanAmount = int.parse(_loanAmount.text);
      int monthlyPayment = int.parse(_monthlyPayment.text);
      int totalRepaymentAmount = int.parse(_totalRepaymentAmount.text);

      await SQLHelper.createItem(
          _borrowerName.text, loanAmount, monthlyPayment, totalRepaymentAmount);
      _refreshBorrowerProfile();
    } catch (e) {
      // Handle parsing error or other exceptions
      print("Error: $e");
    }
  }

  Future _updateItem(int id) async {
    int loanAmount = int.parse(_loanAmount.text);
    int monthlyPayment = int.parse(_monthlyPayment.text);
    int totalRepaymentAmount = int.parse(_totalRepaymentAmount.text);

    await SQLHelper.updateItem(id, _borrowerName.text, loanAmount,
        monthlyPayment, totalRepaymentAmount);
    _refreshBorrowerProfile();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Successfully deleted')));
    _refreshBorrowerProfile();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final borrowerList =
          _borrowerProfile.firstWhere((element) => element['id'] == id);
      _borrowerName.text = borrowerList['borrower'];
      _loanAmount.text = borrowerList['borrow_amount'].toString();
      _monthlyPayment.text = borrowerList['monthly_payment'].toString();
      _totalRepaymentAmount.text =
          borrowerList['total_repayment_amount'].toString();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _borrowerName,
              decoration: const InputDecoration(hintText: 'Borrower Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _loanAmount,
              decoration: const InputDecoration(hintText: 'Loan Amount'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _monthlyPayment,
              decoration: const InputDecoration(hintText: 'Monthly Payment'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _totalRepaymentAmount,
              decoration:
                  const InputDecoration(hintText: 'Total amount with interest'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addItem();
                  }
                  if (id != null) {
                    await _updateItem(id);
                  }

                  _borrowerName.text = '';
                  _loanAmount.text = '';
                  _monthlyPayment.text = '';
                  _totalRepaymentAmount.text = '';
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Submit' : 'Update'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _borrowerProfile.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_borrowerProfile[index]['borrower']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Borrow Amount: ${_borrowerProfile[index]['borrow_amount']}'),
                      Text(
                          'Monthly Payment: ${_borrowerProfile[index]['monthly_payment']}'),
                      Text(
                          'Total Repayment Amount: ${_borrowerProfile[index]['total_repayment_amount']}'),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () =>
                                _showForm(_borrowerProfile[index]['id']),
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () =>
                                _deleteItem(_borrowerProfile[index]['id']),
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
