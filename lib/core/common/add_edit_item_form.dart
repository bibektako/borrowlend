

import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditItemForm extends StatelessWidget {
  final bool isEditMode;

  const AddEditItemForm({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemViewModel, ItemState>(
      buildWhen: (p, c) => p.formStatus != c.formStatus || p.name != c.name || p.description != c.description || p.price != c.price,
      builder: (context, state) {
        final isLoading = state.formStatus == FormStatus.loading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditMode ? 'Edit Your Item' : 'Add a New Item',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // --- Form Fields ---
              TextFormField(
                key: Key(state.itemToEdit?.id ?? 'name'),
                initialValue: state.name,
                decoration: const InputDecoration(labelText: 'Item Name'),
                onChanged: (value) => context.read<ItemViewModel>().add(FormFieldChanged(name: value)),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: Key(state.itemToEdit?.id ?? 'desc'),
                initialValue: state.description,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => context.read<ItemViewModel>().add(FormFieldChanged(description: value)),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: Key(state.itemToEdit?.id ?? 'price'),
                initialValue: state.price,
                decoration: const InputDecoration(labelText: 'Borrowing Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => context.read<ItemViewModel>().add(FormFieldChanged(price: value)),
              ),
              const SizedBox(height: 24),

              // --- Submit Button ---
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        // Dispatch the correct event based on the mode
                        final event = isEditMode ? SubmitEditItemForm() : SubmitAddItemForm();
                        context.read<ItemViewModel>().add(event);
                      },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: isLoading
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                    : Text(isEditMode ? 'Save Changes' : 'Add Item'),
              ),
            ],
          ),
        );
      },
    );
  }
}