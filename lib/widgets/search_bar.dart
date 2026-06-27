import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../constants/app_styles.dart';
import '../utils/routes.dart';
import 'filter_bottom_sheet.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<Product>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Product>.empty();
            }
            return productProvider.allProducts.where(
                (p) => productProvider.fuzzyMatch(textEditingValue.text, p.name)
            );
          },
          displayStringForOption: (Product option) => option.name,
          onSelected: (Product selection) {
            FocusScope.of(context).unfocus();
            Navigator.pushNamed(context, AppRoutes.productDetail, arguments: selection);
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: constraints.maxWidth,
                  margin: const EdgeInsets.only(top: 8),
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppStyles.mediumShadow,
                    border: isDark ? Border.all(color: colorScheme.outline.withValues(alpha: 0.3)) : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.1)),
                      itemBuilder: (context, index) {
                        final Product option = options.elementAt(index);
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(option.image, width: 40, height: 40, fit: BoxFit.cover),
                          ),
                          title: Text(option.name, style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text(option.category, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            focusNode.addListener(() {
              if (mounted) {
                setState(() {
                  _isFocused = focusNode.hasFocus;
                });
              }
            });

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(30.0),
                border: _isFocused
                    ? Border.all(color: colorScheme.primary.withValues(alpha: 0.5), width: 1.5)
                    : Border.all(color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : isDark
                        ? []
                        : AppStyles.subtleShadow,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.search,
                      key: ValueKey(_isFocused),
                      color: _isFocused
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (value) {
                        Provider.of<ProductProvider>(context, listen: false)
                            .setSearchQuery(value);
                        setState(() {});
                      },
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: textEditingController.text.isNotEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: textEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                              size: 20,
                            ),
                            onPressed: () {
                              textEditingController.clear();
                              Provider.of<ProductProvider>(context, listen: false)
                                  .setSearchQuery('');
                              setState(() {});
                            },
                          )
                        : const SizedBox(width: 0),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FilterBottomSheet(),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
