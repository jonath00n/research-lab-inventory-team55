import 'package:flutter/material.dart';
import 'authentication_db.dart';
import 'home_page.dart';
import 'checkout_page.dart';
import 'package:google_fonts/google_fonts.dart';
// all packages and other pages referenced for this page ^




class ItemsListScreen extends StatefulWidget {
  final String searchQuery;
  ItemsListScreen({required this.searchQuery});

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _performSearch(widget.searchQuery);
  }

  Future<void> _performSearch(String query) async {
    List<Map<String, dynamic>> results;

    if (query == "*") {
      results = await AuthenticationDB().getItems();
    } else {
      results = await AuthenticationDB().searchDropdownItems(query);
    }

    setState(() {
      _items = results;
    });
  }

  Future<void> _loadItems() async {
    final dbStuff = AuthenticationDB();
    final data = await AuthenticationDB().getItems();
    setState(() {
      _items = data;
    });
    _items = data;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items List')),
      body: _items.isEmpty ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: DataTable(
          columnSpacing: 15, // Reduces the space between columns
          columns: [
            DataColumn(label: Text('Item',style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),
            DataColumn(label: Text('Quantity', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),
            DataColumn(label: Text('Availability', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),
          /*  DataColumn(label: Text('Returnable?', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),  */
            DataColumn(label: Text('Image', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),
          ],
          rows: _items
              .map(
                (item) => DataRow(
              cells: [
                DataCell(
                  Text(item['item'],
                    style: GoogleFonts.roboto(
                    fontSize: 15,
                  ),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(item: item),
                      ),
                    );
                  },
                ),
                DataCell(Text(item['quantity']?.toString() ?? 'No Item', style: GoogleFonts.roboto(
                  fontSize: 15,
                ),)),
                DataCell(Text(item['availability']?.toString() ?? '0', style: GoogleFonts.roboto(
                  fontSize: 15,
                ),)),
              /*  DataCell(Text(item['returnable']?.toString() ?? '0', style: GoogleFonts.roboto(
                  fontSize: 15,
                ),)), */
                DataCell(
                   Image.asset(
                       'assets/${item['item']}.png', // Dynamically constructs asset path
                         width: 80,
                         height: 30,
                           fit: BoxFit.cover,
                     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                     // Show icon if image loading fails
                     return Icon(
                       Icons.image_not_supported_outlined,
                       size: 30,
                       color: Colors.grey,
                     );
                   },


                   )
                  // : Icon(Icons.image_not_supported), // Placeholder if no image
                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
      floatingActionButton: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
    child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(12),
    ),

        child: Text('Back to Search Page',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      ),
    );

  }

}
