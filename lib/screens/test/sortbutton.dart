import 'package:flutter/material.dart';

class SortFilterButton extends StatefulWidget {
  const SortFilterButton({Key? key}) : super(key: key);

  @override
  _SortFilterButtonState createState() => _SortFilterButtonState();
}

class _SortFilterButtonState extends State<SortFilterButton> {
  String _selectedOption = 'All';

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Sort/Filter By',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        RadioListTile<String>(
                          title: const Text('All'),
                          value: 'All',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                            
                            print(_selectedOption);
                            
                            // setState(() {
                              
                            // });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Option 1'),
                          value: 'Option 1',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Option 2'),
                          value: 'Option 2',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Option 3'),
                          value: 'Option 3',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            // print("Tile Clicked")
                            setState(() {
                              _selectedOption = value!;
                            });
                            
                            // Navigator.pop(context, _selectedOption);
                          },
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Apply the selected option and close the modal bottom sheet
                      
                      Navigator.pop(context, _selectedOption);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        ).then((selectedOption) {
          if (selectedOption != null) {
            // Do something with the selected option
            print('Selected Option: $selectedOption');
          }
        });
      },
      child: const Icon(Icons.sort),
    );
  }
}