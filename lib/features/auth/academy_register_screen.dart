import 'package:flutter/material.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/app_input.dart';
import 'otp_verification_screen.dart';

/// Academy Registration Screen
/// Multi-step form for academy signup
class AcademyRegisterScreen extends StatefulWidget {
  const AcademyRegisterScreen({super.key});

  @override
  State<AcademyRegisterScreen> createState() => _AcademyRegisterScreenState();
}

class _AcademyRegisterScreenState extends State<AcademyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _academyNameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  
  String? _selectedType;
  String? _selectedState;
  List<String> _selectedSports = [];
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _academyTypes = ['Private', 'Government', 'SAI Affiliated'];
  final List<String> _sports = [
    'Cricket', 'Football', 'Hockey', 'Basketball', 
    'Athletics', 'Swimming', 'Badminton', 'Tennis',
    'Kabaddi', 'Wrestling', 'Boxing', 'Volleyball'
  ];
  final List<String> _states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar',
    'Chhattisgarh', 'Delhi', 'Goa', 'Gujarat', 'Haryana',
    'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala',
    'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
    'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan',
    'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
  ];

  @override
  void dispose() {
    _academyNameController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _register();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _previousStep,
        ),
        title: const Text(
          'Register Academy',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? AppTheme.primaryOrange
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Step Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildStepContent(),
                ),
              ),
              
              // Next Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: AppPrimaryButton(
                  text: _currentStep == 2 ? 'Register Academy' : 'Continue',
                  isLoading: _isLoading,
                  onPressed: _nextStep,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildAcademyInfoStep();
      case 1:
        return _buildSportsStep();
      case 2:
        return _buildLocationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAcademyInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academy Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about your academy',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        
        AppTextField(
          controller: _academyNameController,
          label: 'Academy Name',
          hint: 'Enter academy name',
          prefixIcon: const Icon(Icons.business_outlined),
        ),
        
        const SizedBox(height: 20),
        
        const Text(
          'Academy Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          value: _selectedType,
          hint: 'Select academy type',
          items: _academyTypes,
          onChanged: (value) => setState(() => _selectedType = value),
        ),
        
        const SizedBox(height: 20),
        
        AppTextField(
          controller: _contactNameController,
          label: 'Contact Person',
          hint: 'Enter contact person name',
          prefixIcon: const Icon(Icons.person_outline),
        ),
      ],
    );
  }

  Widget _buildSportsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sports Offered',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select all sports your academy offers',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _sports.map((sport) {
            final isSelected = _selectedSports.contains(sport);
            return GestureDetector(
              onTap: () => _toggleSport(sport),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryOrange
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryOrange
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  sport,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        if (_selectedSports.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Selected: ${_selectedSports.join(", ")}',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location & Contact',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Where is your academy located?',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        
        AppTextField(
          controller: _addressController,
          label: 'Address',
          hint: 'Enter academy address',
          prefixIcon: const Icon(Icons.location_on_outlined),
          maxLines: 2,
        ),
        
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'City',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'City',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'State',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    value: _selectedState,
                    hint: 'State',
                    items: _states,
                    onChanged: (value) => setState(() => _selectedState = value),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        PhoneInputField(
          controller: _phoneController,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'We\'ll verify your academy after registration',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
