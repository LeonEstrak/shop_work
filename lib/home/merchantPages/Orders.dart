import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopwork/services/database.dart';
import 'package:shopwork/shared/constants.dart';

class Orders extends StatefulWidget {
  Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context);
    List names = ["Swattik", "Customer", "Aniket"];
    List numberOfItems = [1, 2, 1];
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Orders",
            style: TextStyle(
              fontSize: 40,
              // color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              /// Stream Builder is used here to check the database, whenever updated,
              /// the GridView is to be rebuilt.
              stream: DatabaseServices(uid: user.uid).allItemsAsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List _allItems = snapshot.data[Constant.items.toString()];

                  ///_allitems.length called on null results in error
                  int itemsLength;
                  if (_allItems == null)
                    itemsLength = 0;
                  else
                    itemsLength = _allItems.length;

                  return ListView(
                      children: List.generate(
                          3,
                          (index) => OrderCard(
                                customerName: names[index],
                                numberOfItems: numberOfItems[index].toString(),
                              )));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String customerName, numberOfItems;
  const OrderCard({this.customerName, this.numberOfItems, Key key})
      : super(key: key);

  showProfilePhoto() {
    return Image.asset(
      "lib/shared/addimage.png",
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: 100,
              clipBehavior: Clip.hardEdge,
              child: showProfilePhoto(),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Colors.black12),
            ),
          ),
          Expanded(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.customerName,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Number of items: " + this.numberOfItems,
                    style: TextStyle(fontSize: 15),
                  )
                ]),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3.0,
                blurRadius: 5.0)
          ]),
    );
  }
}
