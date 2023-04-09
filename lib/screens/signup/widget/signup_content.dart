import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:personal_training_app/core/const/color_constants.dart';
import 'package:personal_training_app/core/const/text_constants.dart';
import 'package:personal_training_app/screens/signup/bloc/signup_bloc.dart';

import '../../../core/ common_widgets/custom_button.dart';
import '../../../core/ common_widgets/custom_text_field.dart';
import '../../../core/ common_widgets/loading_widget.dart';
import '../../../core/service/validation_service.dart';

class SignUpContent extends StatelessWidget {
  const SignUpContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorConstants.backgroundWhite,
        child: Stack(
          children: [
            _createMainData(context),
            BlocBuilder<SignupBloc, SignupState>(
                buildWhen: (_, currState) =>
                    currState is LoadingState ||
                    currState is NextLoginPageState ||
                    currState is ErrorState ||
                    currState is LoadedState,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return _createLoading();
                  } else if (state is NextLoginPageState ||
                      state is ErrorState ||
                      state is LoadedState) {
                    return const SizedBox();
                  }
                  return const SizedBox();
                })
          ],
        ),
      ),
    );
  }

  Widget _createMainData(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _createTitle(),
          const SizedBox(
            height: 20,
          ),
          _createForm(context),
          const SizedBox(
            height: 20,
          ),
          _createSignUpButton(context),
          const SizedBox(
            height: 20,
          ),
          _createHaveAnAccount(context),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  Widget _createLoading() {
    return const LoadingWidget();
  }

  Widget _createTitle() {
    return const Text(
      TextConstants.signUp,
      style: TextStyle(
          color: ColorConstants.textBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _createSignUpButton(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (_, currState) =>
            currState is SignUpButtonEnableChangedState,
        builder: (context, state) {
          return CustomButton(
            title: TextConstants.signUp,
            isEnabled: state is SignUpButtonEnableChangedState
                ? state.isEnabled
                : false,
            onTap: () {
              FocusScope.of(context).unfocus();
              bloc.add(SignUpTappedEvent());
            },
          );
        },
      ),
    );
  }

  Widget _createForm(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (_, currState) =>
          currState is ShowErrorState || currState is LoadedState,
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              title: 'Username',
              placeholder: 'username01',
              errorText: 'Invalid username',
              controller: bloc.userNameController,
              isError: state is ShowErrorState
                  ? !ValidationService.username(bloc.userNameController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Email',
              placeholder: 'example@email.com',
              errorText: 'Invalid email',
              controller: bloc.emailController,
              isError: state is ShowErrorState
                  ? !ValidationService.email(bloc.emailController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Password',
              placeholder: 'Must be at least 6 symbols',
              errorText: 'Weak password',
              controller: bloc.passwordController,
              isError: state is ShowErrorState
                  ? !ValidationService.password(bloc.passwordController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Confirm Password',
              placeholder: 'Re-enter password',
              errorText: 'Passwords are not same',
              controller: bloc.confirmPasswordController,
              isError: state is ShowErrorState
                  ? !ValidationService.confirmPassword(
                      bloc.passwordController.text,
                      bloc.confirmPasswordController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            _createDatePicker(context),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Weight',
              placeholder: 'Enter your weight in kg',
              errorText: 'Enter weight in digits',
              controller: bloc.weightController,
              isError: state is ShowErrorState
                  ? !ValidationService.onlyDouble(bloc.weightController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Height',
              placeholder: 'Enter your height in cm',
              errorText: 'Enter height in digits',
              controller: bloc.heightController,
              isError: state is ShowErrorState
                  ? !ValidationService.onlyDouble(bloc.heightController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Gender',
              placeholder: 'Male/Female',
              errorText: 'Enter your gender',
              controller: bloc.genderController,
              isError: state is ShowErrorState
                  ? !ValidationService.onlyLetters(bloc.genderController.text)
                  : false,
              onTextChanged: () {
                bloc.add(OnTextChangedEvent());
              },
            ),
            const SizedBox(height: 20),
            _createGoalsList(context),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _createDatePicker(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    FocusNode focusNode = FocusNode();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date of birth",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            focusNode: focusNode,
            controller: bloc.dobController,
            textInputAction: TextInputAction.done,
            style:
                const TextStyle(color: ColorConstants.textBlack, fontSize: 16),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                        color:
                            ColorConstants.textFieldBorder.withOpacity(0.5))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: ColorConstants.secondaryColor)),
                hintText: 'Enter your birthday',
                hintStyle:
                    const TextStyle(color: ColorConstants.grey, fontSize: 16),
                filled: true,
                fillColor: ColorConstants.textFieldBackground),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: ColorConstants.secondaryColor
                              .withOpacity(0.7), // header background color
                          onPrimary:
                              ColorConstants.textBlack, // header text color
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: ColorConstants
                                .secondaryColor, // button text color
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                  initialDate: DateTime.now(),
                  //get today's date
                  firstDate: DateTime(1950),
                  //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime.now());
              if (pickedDate != null) {
                bloc.dobController.text =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                bloc.add(OnTextChangedEvent());
              }
            },
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _createGoalsList(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Goals",
            style: TextStyle(
              color: ColorConstants.textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MultiSelectDialogField(
            checkColor: ColorConstants.secondaryColor,
            buttonIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: BoxDecoration(
                color: ColorConstants.textFieldBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: ColorConstants.textFieldBorder.withOpacity(0.5))),
            buttonText: const Text(
              "Select your goal",
              style: TextStyle(color: ColorConstants.textBlack, fontSize: 16),
            ),
            searchable: true,
            title: const Text("Goals"),
            itemsTextStyle:
                const TextStyle(color: ColorConstants.textBlack, fontSize: 16),
            selectedItemsTextStyle:
                const TextStyle(color: ColorConstants.textBlack, fontSize: 16),
            items: bloc.goals.map((e) => MultiSelectItem(e, e.name)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              bloc.selectedGoals
                ..clear()
                ..addAll(values.map((e) => e.name).toList());
              bloc.add(OnTextChangedEvent());
            },
          ),
        )
      ],
    );
  }

  Widget _createHaveAnAccount(BuildContext context) {
    final bloc = BlocProvider.of<SignupBloc>(context);
    return Text.rich(TextSpan(
        text: "Already have an account?",
        style: const TextStyle(color: ColorConstants.textBlack, fontSize: 18),
        children: [
          TextSpan(
              text: " ${TextConstants.signIn}",
              style: const TextStyle(
                  color: ColorConstants.secondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  bloc.add(LoginTappedEvent());
                })
        ]));
  }
}
