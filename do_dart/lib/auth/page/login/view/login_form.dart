import 'package:do_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          _TitleLabel(),
          SizedBox(height: 8.0),
          _SubtitleLabel(),
          SizedBox(height: 35.0),
          _UsernameInput(),
          SizedBox(height: 8.0),
          _ForgotPasswordLabel(),
          _PasswordInput(),
          SizedBox(height: 24.0),
          _LoginButton(),
          _AdditionalTitleLabel(),
          SizedBox(height: 20.0),
          _GoogleLogin(),
          SizedBox(height: 20.0),
          _RegisterLink(),
          SizedBox(height: 35.0),
          _TermsConditionLink()
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginform_username'),
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Username or email :',
            hintText: 'Username / Email',
            contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            errorText: state.username.invalid ? 'invalid username' : null,
          ),
          onChanged: (username) =>
              context.bloc<LoginBloc>().add(LoginUsernameChanged(username)),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
            key: const Key('loginForm_password'),
            autofocus: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password :',
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              errorText: state.password.invalid ? 'invalid password' : null,
            ),
            onChanged: (password) =>
                context.bloc<LoginBloc>().add(LoginPasswordChanged(password)));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Container(
                decoration: state.status.isSubmissionInProgress
                    ? null
                    : BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(2, 2),
                              blurRadius: 2.0),
                        ],
                      ),
                child: MaterialButton(
                  color: AppTheme.button,
                  disabledColor: AppTheme.buttonDisable,
                  minWidth: 200.0,
                  height: 48.0,
                  onPressed: state.status.isValidated
                      ? () {
                          context.bloc<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: state.status.isSubmissionInProgress
                              ? AppTheme.buttonTextDisable
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _TitleLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Login',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontSize: 35,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SubtitleLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'Hello! Login with your username or email.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _ForgotPasswordLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: () {},
        ));
  }
}

class _AdditionalTitleLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        'or enter with:',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTheme.fontName,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _GoogleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/eva_icons/fill/svg/google.svg',
        color: AppTheme.colorTheme,
      ),
      onPressed: () {},
    );
  }
}

class _RegisterLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  'Don' 't have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            InkWell(
              onTap: () {},
              child: new Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.colorTheme,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ]),
    );
  }
}

class _TermsConditionLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () {},
        child: new Text(
          'Terms & Conditions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.colorTheme,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}