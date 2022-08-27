import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/widgets/widgets.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.cancel))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        textTheme: TextTheme(headline6: TextStyle()));
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection(FirebaseCollections.SHOP_COLLECTIONS)
          .where('name', isEqualTo: query)
          .get(),
      builder:
          (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.docs.length == 0) {
            return NoRecord();
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (_, index) {
              final doc = snapshot.data!.docs[index];
              final shop = Shop.fromMap(doc.data(), doc.id);
              return Card(
                child: ListTile(
                  onTap: (){
                    Navigator.of(context).pushNamed(ShopDetailScreen.routeName,arguments: shop);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(shop.images[0]),
                  ),
                  trailing: Container(
                    width: 50,
                    child: Row(
                      children: [
                        Text(
                          '(${shop.rating})',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 02,
                        ),
                        Icon(
                          Icons.star,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    shop.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
        }
        return Loading();
      },
    );
  }
}
