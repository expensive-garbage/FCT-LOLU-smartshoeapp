import 'package:flutter/material.dart';
import 'package:namer_app/MyApp.dart';
import 'package:provider/provider.dart';

class AddShoePage extends StatelessWidget {
  const AddShoePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return Center(
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un nom';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
