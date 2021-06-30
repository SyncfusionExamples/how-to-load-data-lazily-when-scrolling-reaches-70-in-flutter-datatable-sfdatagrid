import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

/// The application that contains datagrid on it.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

/// The home page of the application which hosts the datagrid.
class MyHomePage extends StatefulWidget {
  /// Creates the home page.
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

late ScrollController verticalController;

class _MyHomePageState extends State<MyHomePage> {
  late _EmployeeDataSource employeeDataSource;

  void verticalListner() {
    if (verticalController.position.pixels >=
        verticalController.position.maxScrollExtent * (70 / 100)) {
      employeeDataSource.loadMoreRows();
    }
  }

  @override
  void initState() {
    super.initState();
    employeeDataSource = _EmployeeDataSource();
    verticalController = ScrollController()..addListener(verticalListner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataGrid Sample'),
      ),
      body: SfDataGrid(
          source: employeeDataSource,
          allowSwiping: true,
          verticalScrollController: verticalController,
          columnWidthMode: ColumnWidthMode.fill,
          columns: _getColumns()),
    );
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'id',
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text(
                'Order ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'customerId',
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text(
                'Customer ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'name',
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: Text(
                'Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'freight',
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text(
                'Freight',
                overflow: TextOverflow.ellipsis,
              ))),
    ];
  }
}

class _Employee {
  _Employee(
      this.id, this.customerId, this.name, this.freight, this.city, this.price);
  final int id;
  final int customerId;
  final String name;
  final String city;
  final double freight;
  final double price;

  DataGridRow get getDataGridRow => DataGridRow(cells: [
        DataGridCell(columnName: 'id', value: id),
        DataGridCell(columnName: 'customerId', value: customerId),
        DataGridCell(columnName: 'name', value: name),
        DataGridCell(columnName: 'freight', value: freight),
      ]);
}

class _EmployeeDataSource extends DataGridSource {
  _EmployeeDataSource() {
    loadEmployees(25);
  }

  List<_Employee> employees = [];

  List<DataGridRow> dataGridRows = [];

  // Overrides
  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.centerRight,
        child: Text(
          NumberFormat.currency(locale: 'en_US', symbol: '\$')
              .format(row.getCells()[3].value)
              .toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  void loadMoreRows() {
    loadEmployees(15);
    notifyListeners();
  }

  void updateDataGridDataSource() {
    notifyListeners();
  }

  // Employee Data's

  final List<String> names = <String>[
    'Welli',
    'Blonp',
    'Folko',
    'Furip',
    'Folig',
    'Picco',
    'Frans',
    'Warth',
    'Linod',
    'Simop',
    'Merep',
    'Riscu',
    'Seves',
    'Vaffe',
    'Alfki',
  ];

  final List<String> cities = <String>[
    'Bruxelles',
    'Rosario',
    'Recife',
    'Graz',
    'Montreal',
    'Tsawassen',
    'Campinas',
    'Resende',
  ];

  void loadEmployees(int count) {
    final Random random = Random();
    final int startIndex = employees.isNotEmpty ? employees.length : 0,
        endIndex = startIndex + count;

    for (int i = startIndex; i < endIndex; i++) {
      var employee = _Employee(
        1000 + i,
        1700 + i,
        names[i < names.length ? i : random.nextInt(names.length - 1)],
        random.nextInt(1000) + random.nextDouble(),
        cities[random.nextInt(cities.length - 1)],
        1500.0 + random.nextInt(100),
      );
      employees.add(employee);
      dataGridRows.add(employee.getDataGridRow);
    }
  }
}
