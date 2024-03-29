import 'package:contact_book/pages/add_contact.dart';
import 'package:contact_book/services/providers/contacts_provider.dart';
import 'package:contact_book/widgets/HomePageWidgets/contacts/contacts_list_builder.dart';
import 'package:contact_book/widgets/HomePageWidgets/dashboard.dart';
import 'package:contact_book/widgets/HomePageWidgets/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<ContactListProvider>(context, listen: false)
          .loadContactsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactListProvider>(
        builder: (context, contactlistprovider, child) => Scaffold(
              floatingActionButton: const CustomFloatingButton(),
              appBar: AppBar(title: const Text("Contact Book !")),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: contactlistprovider.registeredContacts.isEmpty
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddContacts()));
                          },
                          child: const Text(
                              "No contacts found ! Click to add contacts!"))
                      : const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DashBoard(),
                            SizedBox(height: 20),
                            Expanded(child: ContactListBuilder())
                          ],
                        ),
                ),
              ),
            ));
  }
}
