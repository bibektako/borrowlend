import 'dart:io';
import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_state.dart';
import 'package:borrowlend/features/category/presentation/view_model/category_viewmodel.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';

class AddItemView extends StatelessWidget {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    return BlocListener<ItemViewModel, ItemState>(
      listenWhen: (p, c) => p.formStatus != c.formStatus,
      listener: (context, state) {
        if (state.formStatus == FormStatus.success) {
          showMySnackBar(
            context: context,
            message: "Item listed successfully!",
            type: SnackBarType.success,
          );
          Future.delayed(Duration.zero, () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        } else if (state.formStatus == FormStatus.failure) {
          showMySnackBar(
            context: context,
            message:
                state.errorMessage ?? 'Failed to add item. Please try again.',
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Item')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<ItemViewModel, ItemState>(
            builder: (context, state) {
              final isLoading = state.formStatus == FormStatus.loading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final file = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      ); // Force JPEG conversion
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
                      child:
                          state.imagePaths.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(state.imagePaths.first),
                                  fit: BoxFit.cover,
                                ),
                              )
                              : const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Form Fields ---
                  TextFormField(
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
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
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
                              SubmitAddItemForm(),
                            ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text('List My Item'),
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
