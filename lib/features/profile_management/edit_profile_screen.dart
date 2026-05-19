import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:advsw/theme/app_theme.dart';
import 'package:advsw/models/user_model.dart';
import 'package:advsw/providers/user_provider.dart';
import 'package:advsw/services/api_client.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  AvailabilityStatus _availabilityStatus = AvailabilityStatus.AVAILABLE;
  File? _selectedImage;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final profile = ref.read(userProfileProvider).value;
    if (profile != null) {
      setState(() {
        _firstNameController.text = profile.firstName;
        _lastNameController.text = profile.lastName;
        _bioController.text = profile.bio;
        _availabilityStatus = profile.availabilityStatus;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final bio = _bioController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('First name and last name are required.'), backgroundColor: Colors.red),
        );
      }
      setState(() => _saving = false);
      return;
    }

    try {
      if (_selectedImage != null) {
        await ref.read(userProfileProvider.notifier).uploadProfilePicture(_selectedImage!.path);
      }

      final request = UpdateProfileRequest(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        availabilityStatus: _availabilityStatus,
      );

      await ref.read(userProfileProvider.notifier).updateProfile(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final existingAvatarUrl = profile?.profilePictureUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save', style: TextStyle(color: AppColors.teal700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePictureSection(existingAvatarUrl),
            const SizedBox(height: 24),
            _buildSectionTitle('Personal Information'),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Availability Status'),
            _buildAvailabilitySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(String? existingAvatarUrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lineSoft),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.teal50,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (existingAvatarUrl != null
                          ? NetworkImage(ApiClient.buildImageUrl(existingAvatarUrl)!)
                          : null) as ImageProvider?,
                  child: _selectedImage == null && existingAvatarUrl == null
                      ? Text(
                          '${_firstNameController.text.isNotEmpty ? _firstNameController.text[0] : ''}${_lastNameController.text.isNotEmpty ? _lastNameController.text[0] : ''}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.teal700),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.teal700,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tap to change profile picture',
            style: TextStyle(fontSize: 12, color: AppColors.ink500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink700)),
    );
  }

  Widget _buildAvailabilitySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: AvailabilityStatus.values.map((status) {
          final isSelected = _availabilityStatus == status;
          return GestureDetector(
            onTap: () => setState(() => _availabilityStatus = status),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.teal50 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.teal700 : AppColors.line),
              ),
              child: Row(
                children: [
                  Icon(
                    _getAvailabilityIcon(status),
                    size: 20,
                    color: isSelected ? AppColors.teal700 : AppColors.ink500,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getAvailabilityLabel(status),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.teal700 : AppColors.ink700,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_rounded, size: 18, color: AppColors.teal700),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getAvailabilityIcon(AvailabilityStatus status) {
    switch (status) {
      case AvailabilityStatus.AVAILABLE:
        return Icons.check_circle_outline;
      case AvailabilityStatus.AWAY:
        return Icons.pause_circle_outline;
    }
  }

  String _getAvailabilityLabel(AvailabilityStatus status) {
    switch (status) {
      case AvailabilityStatus.AVAILABLE:
        return 'Available';
      case AvailabilityStatus.AWAY:
        return 'Away';
    }
  }
}
