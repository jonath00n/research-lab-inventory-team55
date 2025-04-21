import 'package:flutter/material.dart';
// import 'authentication_db.dart';
import 'home_page.dart';
import 'checkout_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'external_database.dart'; // external database import for test

// all packages and other pages referenced for this page ^

// this item is the screen that displays the list of items
// displays them in a table format with columns for different attributes

// This creates the ItemListScreen as a stateful widget
// this means that it is able to be changed based on interaction or other events
class ItemsListScreen extends StatefulWidget {
  final String searchQuery;
  ItemsListScreen({required this.searchQuery}); // super.key identifies the key of the specific widget

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

// The line below creates a class for the AddComponentPage
// The underscore makes it private to the dart file
// manages the State of the page and can rebuild the UI when needed
class _ItemsListScreenState extends State<ItemsListScreen> {
  List<Map<String, dynamic>> _items = [];  // initializes items list

  @override
  void initState() {
    super.initState();
    _performSearch(widget.searchQuery); // performs search based on query passed
  }

  Future<void> _performSearch(String query) async {
    List<Map<String, dynamic>> results;

    if (query == "*") {
      results = await ExternalDatabase().getItems();
    } else {  // dropdown menus are no longer used
      results = await ExternalDatabase().searchItems(query);
    }

    setState(() {
      _items = results;  // sets items as the result from the query
    });
  }

  // not used currently
  Future<void> _loadItems() async {
    final database = ExternalDatabase();
    final data = await database.getItems();
    setState(() {
      _items = data;
    });
  }


  // This builds the widget that is the UI for this page
  // It contains more widgets for buttons, text, ect.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items List')),
      body: _items.isEmpty ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: DataTable( // puts items in a data table format
          columnSpacing: 10, // Reduces the space between columns
          columns: [ // sets column names
            DataColumn(label: Text('Item',style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),
            DataColumn(
              label: Transform.translate(
                offset: Offset(-15, 0), // shifts text 10 pixels to the left
                child: Text('Quantity', style: GoogleFonts.roboto(fontSize: 15)),
              ),
            ),
            DataColumn(
              label: Transform.translate(
                offset: Offset(-15, 0), // shifts text 10 pixels to the left
                child: Text('Return?', style: GoogleFonts.roboto(fontSize: 15)),
              ),
            ),
            DataColumn(
              label: Transform.translate(
                offset: Offset(-5, 0), // shifts text 10 pixels to the left
                child: Text('Location', style: GoogleFonts.roboto(fontSize: 15)),
              ),
            ),
          /*  DataColumn(label: Text('Returnable?', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)),  */
           /* DataColumn(label: Text('Image', style: GoogleFonts.roboto(
              fontSize: 15,
            ),)), */
          ],
          rows: _items // sets the rows for the columns
              .map(
                (item) => DataRow(
              cells: [
                DataCell(
                  Container(
                    width: 150, // Adjust this to increase space
                    child: Text(item['Name'],
                      style: GoogleFonts.roboto(fontSize: 15),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(  // this column is tappable
                      context, // it will send you to the associated item checkout screen
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(itemId: item['Id']),
                      ),
                    );
                  },
                ),
                DataCell(Text(item['Quantity']?.toString() ?? 'No Item', style: GoogleFonts.roboto(
                  fontSize: 15, // column for item quantity
                ),)),
                DataCell(
                  Text(
                    item['returnable'] == 1 ? 'YES' : 'NO',
                    style: GoogleFonts.roboto(fontSize: 15),
                  ),
                ),
                DataCell(
                  Text(item['Location']?.toString() ?? 'Unknown',
                    style: GoogleFonts.roboto(fontSize: 15),
                  ),
                ),
              /*  DataCell(Text(item['returnable']?.toString() ?? '0', style: GoogleFonts.roboto(
                  fontSize: 15,
                ),)), */
               /* DataCell(  // column for the image of the item
                   Image.asset( // image is retrieved based on item name
                       'assets/${item['Name']}.png', // item images are pre loaded into the app
                         width: 80,
                         height: 30,
                           fit: BoxFit.cover,
                     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                     // Show icon not supported if image loading fails
                     return Icon(
                       Icons.image_not_supported_outlined,
                       size: 30,
                       color: Colors.grey,
                     );
                   },


                   )
                ), */
              ],
            ),
          )
              .toList(),
        ),
      ),
      floatingActionButton: TextButton( // button that sends the user back to the home page
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomePage()));
          },
    child: Container(  // text and formatting for the button
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
