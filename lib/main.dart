import 'dart:ui';
import 'dart:io';

import 'package:expenses_app_v2/widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      title: "Expenses App",
      theme: ThemeData(
        primarySwatch: Colors.green,
        // accentColor: Colors.yellow,
        errorColor: Colors.purple,
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: "OpenSans",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  List<Transaction> _userTransactions = [
    // Transaction(
    //   id: "0001",
    //   title: "New Shoes for my girlfirend",
    //   amount: 25.00,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "0002",
    //   title: "Gamer PC",
    //   amount: 1875.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "0003",
    //   title: "First amount of the house",
    //   amount: 300.00,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: txDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void StartAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(newTransactionHandler: _addNewTransaction);
        });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListTransactions,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.70,
              child: Chart(
                recentTransactions: _recentTransactions,
              ),
            )
          : txListTransactions
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListTransactions,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.30,
        child: Chart(
          recentTransactions: _recentTransactions,
        ),
      ),
      txListTransactions
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("build() MainDart");
    final mediaQuery = MediaQuery.of(context);

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text("Expenses App"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => StartAddNewTransaction(context),
                  child: Icon(
                    CupertinoIcons.add,
                  ),
                ),
              ],
            ),
          )
        : AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    StartAddNewTransaction(context);
                  }),
            ],
            title: Text(
              "Expenses App",
            ),
          );

    final txListTransactions = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.70,
      child: TransactionsList(
        transactions: _userTransactions,
        deleteTxHandler: _deleteTransaction,
      ),
    );

    final bodyApp = SafeArea(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (isLandscape)
            ..._buildLandscapeContent(
              mediaQuery,
              appBar,
              txListTransactions,
            ),
          if (!isLandscape)
            ..._buildPortraitContent(
              mediaQuery,
              appBar,
              txListTransactions,
            ),
        ]),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyApp,
            navigationBar: appBar,
          )
        : Scaffold(
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      StartAddNewTransaction(context);
                    },
                    child: Icon(Icons.add)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: appBar,
            body: bodyApp,
          );
  }
}
