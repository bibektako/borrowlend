import 'dart:io';

import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';

import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class EditItemView extends StatelessWidget {
  const EditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final itemToEdit = ModalRoute.of(context)!.settings.arguments as ItemEntity;
    final viewModel = context.read<ItemViewModel>();
    if (viewModel.state.itemToEdit?.id != itemToEdit.id) {
      viewModel.add(LoadItemForEditing(item: itemToEdit));
    }

    final ImagePicker picker = ImagePicker();

    return BlocListener<ItemViewModel, ItemState>(
      listenWhen: (p, c) => p.formStatus != c.formStatus,
      listener: (context, state) {
        if (state.formStatus == FormStatus.success) {
          // Use a delayed pop to avoid build errors
          Future.delayed(Duration.zero, () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        } else if (state.formStatus == FormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to save changes'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Item'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                          'Are you sure you want to permanently delete this item?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  context.read<ItemViewModel>().add(
                    DeleteItemEvent(itemId: itemToEdit.id!),
                  );
                  // The listener will handle popping the screen on success.
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ItemViewModel, ItemState>(
            buildWhen:
                (p, c) =>
                    p.formStatus != c.formStatus ||
                    p.name != c.name ||
                    p.description != c.description ||
                    p.price != c.price ||
                    p.imagePaths != c.imagePaths ||
                    p.selectedCategory != c.selectedCategory,
            builder: (context, state) {
              final isLoading = state.formStatus == FormStatus.loading;
              final keyBase = state.itemToEdit?.id ?? 'edit_form';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final file = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (file != null) {
                        context.read<ItemViewModel>().add(
                          FormFieldChanged(imagePaths: [file.path]),
                        );
                      }
                    },
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // child:
                      //     state.imagePaths.isNotEmpty
                      //         ? ClipRRect(
                      //           borderRadius: BorderRadius.circular(12),
                      //           child:
                      //               state.imagePaths.first.startsWith('http')
                      //                   ? Image.network(
                      //                     state.imagePaths.first,
                      //                     fit: BoxFit.cover,
                      //                   )
                      //                   : Image.file(
                      //                     File(state.imagePaths.first),
                      //                     fit: BoxFit.cover,
                      //                   ),
                      //         )
                      //         : const Center(
                      //           child: Text('Tap to change image'),
                      //         ),
                      child:
                          state.imagePaths.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: buildImageWidget(state.imagePaths.first),
                              )
                              : const Center(
                                child: Text('Tap to change image'),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    key: Key('${keyBase}_name'),
                    initialValue: state.name,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => context.read<ItemViewModel>().add(
                          FormFieldChanged(name: value),
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: Key('${keyBase}_desc'),
                    initialValue: state.description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => context.read<ItemViewModel>().add(
                          FormFieldChanged(description: value),
                        ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: Key('${keyBase}_price'),
                    initialValue: state.price,
                    decoration: const InputDecoration(
                      labelText: 'Borrowing Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged:
                        (value) => context.read<ItemViewModel>().add(
                          FormFieldChanged(price: value),
                        ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategorySuccess) {
                        final categoryOptions = categoryState.categories;
                        // Use the correct property name: id
                        final selectedCategoryId =
                            state.selectedCategory.categoryId;
                        final selectedCategoryValue = categoryOptions
                            .firstWhereOrNull(
                              (category) =>
                                  category.categoryId == selectedCategoryId,
                            );

                        return DropdownButtonFormField<CategoryEntity>(
                          value: selectedCategoryValue,
                          hint: const Text('Select a Category'),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items:
                              categoryOptions.map((category) {
                                // Use the correct property name: name
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category.category),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              context.read<ItemViewModel>().add(
                                FormFieldChanged(category: newValue),
                              );
                            }
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select a category'
                                      : null,
                        );
                      }
                      return const Text('Loading categories...');
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () => context.read<ItemViewModel>().add(
                              SubmitEditItemForm(),
                            ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildImageWidget(String path) {
  if (path.startsWith('http')) {
    return Image.network(path, fit: BoxFit.cover);
  }
  if (path.startsWith('/')) {
    return Image.file(File(path), fit: BoxFit.cover);
  } else {
    final fullUrl = '${ApiEndpoints.serverAddress}/$path';
    return Image.network(fullUrl, fit: BoxFit.cover);
  }
}
