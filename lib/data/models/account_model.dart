class AccountModel {
  String? message;
  AccountJournal? accountJournal;

  AccountModel({this.message, this.accountJournal});

  AccountModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accountJournal = json['account_journal'] != null
        ? AccountJournal.fromJson(json['account_journal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (accountJournal != null) {
      data['account_journal'] = accountJournal!.toJson();
    }
    return data;
  }
}

class AccountJournal {
  int? accountId;
  String? direction;
  int? amount;
  String? balanceBefore;
  int? balanceAfter;
  String? updatedAt;
  String? createdAt;
  int? id;

  AccountJournal({
    this.accountId,
    this.direction,
    this.amount,
    this.balanceBefore,
    this.balanceAfter,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  AccountJournal.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    direction = json['direction'];
    amount = json['amount'];
    balanceBefore = json['balance_before'];
    balanceAfter = json['balance_after'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['direction'] = direction;
    data['amount'] = amount;
    data['balance_before'] = balanceBefore;
    data['balance_after'] = balanceAfter;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
