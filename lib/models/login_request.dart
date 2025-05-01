import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

ResetPasswordRequest resetPasswordRequestFromJson(String str) => ResetPasswordRequest.fromJson(json.decode(str));

String resetPasswordRequestToJson(ResetPasswordRequest data) => json.encode(data.toJson());

class LoginRequest {
    final String email;
    final String password;

    LoginRequest({
        required this.email,
        required this.password,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}

class ResetPasswordRequest {
    final String password;
    final String rePassword;

    ResetPasswordRequest({
        required this.password,
        required this.rePassword,
    });

    factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
        password: json["password"],
        rePassword: json["rePassword"],
    );

    Map<String, dynamic> toJson() => {
        "password": password,
        "rePassword": rePassword,
    };
}
