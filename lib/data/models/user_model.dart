class UserModel {
  User? user;

  UserModel({this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? currency;
  String? createdAt;
  String? updatedAt;
  Account? account;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.account,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    account = json['account'] != null
        ? Account.fromJson(json['account'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (account != null) {
      data['account'] = account!.toJson();
    }
    return data;
  }
}

class Account {
  int? id;
  String? userId;
  String? accountNumber;
  String? balance;
  String? currency;
  String? createdAt;
  String? updatedAt;

  Account({
    this.id,
    this.userId,
    this.accountNumber,
    this.balance,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    accountNumber = json['account_number'];
    balance = json['balance'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['account_number'] = accountNumber;
    data['balance'] = balance;
    data['currency'] = currency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
