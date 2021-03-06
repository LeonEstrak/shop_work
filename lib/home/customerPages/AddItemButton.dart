import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopwork/services/database.dart';
import 'package:shopwork/shared/constants.dart';

class AddItemButton extends StatefulWidget {
  final String itemName, itemPrice;
  final String documentID;
  AddItemButton({this.itemName, this.documentID, this.itemPrice});
  @override
  _AddItemButtonState createState() => _AddItemButtonState();
}

class _AddItemButtonState extends State<AddItemButton> {
  Future<int> getNumberOfItemsInCart(FirebaseUser user) async {
    List itemMap = await DatabaseServices(uid: user.uid).allItemsInCart;
    int count = 0;
    if (itemMap == null) return 0;
    itemMap.forEach((item) {
      if (item[Constant.itemName.toString()] == widget.itemName &&
          item[Constant.uid.toString()] == widget.documentID)
        count = item[Constant.itemQty.toString()];
    });
    return count;
  }

  int getItemPrice() {
    var price = int.tryParse(widget.itemPrice);
    if (price == null) price = double.tryParse(widget.itemPrice).toInt();
    return price;
  }

  int itemCount = 0;
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of(context, listen: false);
    return FutureBuilder(
      initialData: itemCount,
      future: getNumberOfItemsInCart(user),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != 0) {
          itemCount = snapshot.data;
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseServices(uid: user.uid).addItemToCart(
                          itemName: widget.itemName,
                          qty: snapshot.data - 1,
                          itemPrice: getItemPrice(),
                          shopDocID: widget.documentID);

                      this.setState(() {
                        itemCount--;
                      });
                    },
                    child: Text("-",
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    itemCount.toString(),
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      await DatabaseServices(uid: user.uid).addItemToCart(
                          itemName: widget.itemName,
                          qty: snapshot.data + 1,
                          itemPrice: getItemPrice(),
                          shopDocID: widget.documentID);

                      this.setState(() {
                        itemCount++;
                      });
                    },
                    child: Text("+",
                        style: TextStyle(color: Colors.green, fontSize: 20)),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data == 0) {
          return ElevatedButton(
            onPressed: () async {
              await DatabaseServices(uid: user.uid).addItemToCart(
                  itemName: widget.itemName,
                  qty: 1,
                  itemPrice: getItemPrice(),
                  shopDocID: widget.documentID);
              this.setState(() {
                itemCount++;
              });
            },
            child: Text(
              "+ Add",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
