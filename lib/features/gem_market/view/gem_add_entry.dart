import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_market/features/gem_market/viewmodel/gem_add_viewmodel.dart';
import 'package:job_market/features/auth/provider/session_provider.dart';

class AddGemScreen extends ConsumerStatefulWidget {
  const AddGemScreen({super.key});

  @override
  ConsumerState<AddGemScreen> createState() => _AddGemScreenState();
}

class _AddGemScreenState extends ConsumerState<AddGemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caratController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _varietyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sellerPhoneController = TextEditingController();

  bool _isPublishing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caratController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    _varietyController.dispose();
    _locationController.dispose();
    _sellerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePublish() async {
    if (!_formKey.currentState!.validate()) return;

    final sessionAsync = ref.read(sessionProvider);
    final currentUser = sessionAsync.value;

    if (currentUser?.supabaseUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to list a new gem.'),
            backgroundColor: Colors.red,
          ),
        );
        context.go('/login');
      }
      return;
    }

    setState(() => _isPublishing = true);

    final success = await ref
        .read(gemAddViewModelProvider.notifier)
        .createGem(
          name: _nameController.text.trim(),
          carat: double.tryParse(_caratController.text.trim()),
          price: double.tryParse(_priceController.text.trim()),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          sellerPhone: _sellerPhoneController.text.trim(),
          variety: _varietyController.text.trim(),
          color: _colorController.text.trim(),
        );

    if (!mounted) return;

    setState(() => _isPublishing = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gem listed successfully and is pending approval.'),
          backgroundColor: Color(0xFF10C971),
        ),
      );
      context.go('/gems');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to list gem. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool optional = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Color(0xFF0F172A)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF10C971), width: 2),
          ),
        ),
        validator: optional
            ? null
            : (value) => (value == null || value.trim().isEmpty)
                  ? 'Please enter $label'
                  : null,
      ),
    );
  }

  Widget _sectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10C971),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'List New Gem',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Create a new gem listing',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fill in the details below. The gem will be submitted as pending approval.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeading('Gem Details'),
                    _buildField(
                      label: 'Gem Name',
                      hint: 'e.g. Royal Blue Sapphire',
                      controller: _nameController,
                    ),
                    _buildField(
                      label: 'Variety',
                      hint: 'e.g. Sapphire, Ruby, Emerald',
                      controller: _varietyController,
                      optional: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Carat',
                            hint: 'e.g. 2.5',
                            controller: _caratController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            optional: true,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildField(
                            label: 'Price',
                            hint: 'e.g. 1,200',
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            optional: true,
                          ),
                        ),
                      ],
                    ),
                    _buildField(
                      label: 'Color',
                      hint: 'e.g. Vivid Blue',
                      controller: _colorController,
                      optional: true,
                    ),
                    _buildField(
                      label: 'Location',
                      hint: 'e.g. Colombo',
                      controller: _locationController,
                      optional: true,
                    ),
                    _buildField(
                      label: 'Seller Phone',
                      hint: 'e.g. +94 77 123 4567',
                      controller: _sellerPhoneController,
                      keyboardType: TextInputType.phone,
                      optional: true,
                    ),
                    _buildField(
                      label: 'Description',
                      hint: 'Describe the gem quality and history',
                      controller: _descriptionController,
                      maxLines: 4,
                      optional: true,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isPublishing ? null : _handlePublish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10C971),
                          disabledBackgroundColor: const Color(0xFF86EFAC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isPublishing
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Publish Gem',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
