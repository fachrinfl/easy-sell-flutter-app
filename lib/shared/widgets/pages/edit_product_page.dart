import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/product_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/pos/models/product.dart';
import '../atoms/app_button.dart';
import '../atoms/app_card.dart';
import '../atoms/app_text.dart';
import '../atoms/app_text_field.dart';
import '../molecules/app_app_bar.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _minStockController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name'] ?? '');
    _priceController = TextEditingController(
      text: (widget.product['price'] ?? 0.0).toString(),
    );
    _stockController = TextEditingController(
      text: (widget.product['stock'] ?? 0).toString(),
    );
    _minStockController = TextEditingController(
      text: (widget.product['minStock'] ?? 0).toString(),
    );
    _categoryController = TextEditingController(
      text: widget.product['category'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product['description'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        titleWidget: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: AppText(
            'Edit Product',
            variant: AppTextVariant.titleLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductForm(),
                const SizedBox(height: AppSpacing.xl),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('Product Information', variant: AppTextVariant.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Product Name',
              controller: _nameController,
              hint: 'Enter product name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Price',
                    controller: _priceController,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a valid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Category',
                    controller: _categoryController,
                    hint: 'e.g., Beverages',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Current Stock',
                    controller: _stockController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stock is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Minimum Stock',
                    controller: _minStockController,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Minimum stock is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Description',
              controller: _descriptionController,
              hint: 'Enter product description (optional)',
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppButton(
            'Save Changes',
            variant: AppButtonVariant.primary,
            onPressed: _isLoading ? null : _saveProduct,
            icon: _isLoading ? null : Icons.save,
            loading: _isLoading,
          ),
        ),
      ],
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final productService = ref.read(productServiceProvider);

        final updatedProduct = Product(
          id: widget.product['id'] ?? '',
          businessId: widget.product['businessId'] ?? '',
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text),
          sku: widget.product['sku'] ?? '',
          category: _categoryController.text.trim(),
          stock: int.parse(_stockController.text),
          minStock: int.parse(_minStockController.text),
          imageUrl: widget.product['imageUrl'],
          isActive: widget.product['isActive'] ?? true,
          createdAt: widget.product['createdAt'] != null
              ? DateTime.parse(widget.product['createdAt'].toString())
              : DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await productService.updateProduct(
          productId: updatedProduct.id,
          name: updatedProduct.name,
          description: updatedProduct.description,
          price: updatedProduct.price,
          sku: updatedProduct.sku,
          category: updatedProduct.category,
          stock: updatedProduct.stock,
          minStock: updatedProduct.minStock,
          imageUrl: updatedProduct.imageUrl,
          isActive: updatedProduct.isActive,
        );

        if (mounted) {
          _showSnackBar('Product updated successfully!');
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Error updating product: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
