// ignore_for_file: use_build_context_synchronously, empty_catches

import 'package:flutter/material.dart';
import 'package:contact_book/services/providers/contacts_provider.dart';
import 'package:provider/provider.dart';
import 'package:contact_book/services/model/contact_model.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class DeviceContacts extends StatefulWidget {
  const DeviceContacts({super.key});

  @override
  State<DeviceContacts> createState() => _DeviceContactsState();
}

class _DeviceContactsState extends State<DeviceContacts> {
  FullContact nullFunction = FullContact([], [], [], [],
      StructuredName('', '', '', ''), null, null, null, null, [], []);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactListProvider>(
      builder: (context, contactlistprovider, child) => Scaffold(
        appBar: AppBar(centerTitle: true, actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  try {
                    if (contactlistprovider.fetchedContact
                        .toString()
                        .isNotEmpty) {
                      contactlistprovider.addContact(
                          contactlistprovider.fetchedContact.name!.firstName
                              .toString(),
                          contactlistprovider.fetchedContact.company.toString(),
                          contactlistprovider.fetchedContact.phones[0].toString(),
                          contactlistprovider.fetchedContact.relations
                              .toString(),
                          contactlistprovider.fetchedContact.emails.toString(),
                          contactlistprovider.defaultGroup,
                          contactlistprovider.defaultDepartment);
                      contactlistprovider.updateFetchContact(nullFunction);

                      Navigator.pop(context);
                    }
                  } catch (e) {}
                },
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 20),
                )),
          )
        ]),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(children: [
                  Container(
                    color: const Color.fromARGB(73, 124, 77, 255),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextButton(
                        onPressed: () async {
                          try {
                            bool perm =
                                await FlutterContactPicker.requestPermission();
                            if (perm) {
                              if (await FlutterContactPicker.hasPermission()) {
                                contactlistprovider.updateFetchContact(
                                    await FlutterContactPicker
                                        .pickFullContact());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.white,
                                    content: Center(
                                      child: Text(
                                        'Contact picked successfully',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.white,
                                content: Center(
                                  child: Text(
                                    'Unable to select contact',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("CLICK TO SELECT DEVICE CONTACT")),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Department",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      DropdownButton(
                        value: contactlistprovider.defaultDepartment,
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          contactlistprovider.changeDepartment(value);
                        },
                        items: Department.values
                            .map(
                              (group) => DropdownMenuItem(
                                value: group,
                                child: Text(group.name.toUpperCase()),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  )
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
