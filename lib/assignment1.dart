// 1️. Abstract Base Class

abstract class BankAccount {
  // Private fields (encapsulation)
  String _accountNumber;
  String _accountHolder;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters and Setters (Encapsulation)
  String get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  set balance(double amount) {
    _balance = amount;
  }

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // Display account information
  void displayInfo() {
    print("Account Holder: $_accountHolder");
    print("Account Number: $_accountNumber");
    print("Current Balance: \$${_balance.toStringAsFixed(2)}");
  }
}

// 2️ Interest

abstract class InterestBearing {
  void calculateInterest();
}

// 3️ SavingsAccount

class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;

  SavingsAccount(String accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Savings Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 500) {
      print(" Cannot withdraw. Minimum balance of \$500 required.");
    } else if (_withdrawCount >= 3) {
      print("Withdrawal limit of 3 per month reached.");
    } else {
      balance -= amount;
      _withdrawCount++;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Savings Account.");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.02;
    balance += interest;
    print(" 2% interest (\$${interest.toStringAsFixed(2)}) added.");
  }
}

// 4️ CheckingAccount

class CheckingAccount extends BankAccount {
  CheckingAccount(String accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Checking Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      balance -= (amount + 35);
      print("Withdrew \$${amount.toStringAsFixed(2)} from Checking Account.");
      print(" Overdraft! \$35 fee applied.");
    } else {
      balance -= amount;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Checking Account.");
    }
  }
}

// 5️ PremiumAccount

class PremiumAccount extends BankAccount implements InterestBearing {
  PremiumAccount(String accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount.toStringAsFixed(2)} to Premium Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 10000) {
      print(" Minimum balance of \$10,000 required.");
    } else {
      balance -= amount;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Premium Account.");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.05;
    balance += interest;
    print(" 5% interest (\$${interest.toStringAsFixed(2)}) added.");
  }
}

// 6️ StudentAccount (Extension)

class StudentAccount extends BankAccount {
  StudentAccount(String accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (balance + amount > 5000) {
      print("Cannot exceed \$5000 maximum balance for Student Account.");
    } else {
      balance += amount;
      print("Deposited \$${amount.toStringAsFixed(2)} to Student Account.");
    }
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print("Insufficient funds in Student Account.");
    } else {
      balance -= amount;
      print("Withdrew \$${amount.toStringAsFixed(2)} from Student Account.");
    }
  }
}

// 7️ Bank Class

class Bank {
  final List<BankAccount> _accounts = [];

  // Create new account
  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created for ${account.accountHolder}");
  }

  // Find account by number
  BankAccount? findAccount(String accNo) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accNo);
    } catch (e) {
      print("Account not found!");
      return null;
    }
  }

  // Transfer money between accounts
  void transfer(String from, String to, double amount) {
    var sender = findAccount(from);
    var receiver = findAccount(to);

    if (sender == null || receiver == null) {
      print("Transfer failed due to invalid account(s).");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);
    print("Transferred \$${amount.toStringAsFixed(2)} from $from to $to.\n");
  }

  // Generate Report
  void showReport() {
    print("\n --- Bank Report ---");
    for (var acc in _accounts) {
      acc.displayInfo();
      print("-----------------------");
    }
  }
}

// 8️ MAIN FUNCTION

void main() {
  Bank bank = Bank();

  // Create Accounts
  var acc1 = SavingsAccount("1001", "Ram", 1000);
  var acc2 = CheckingAccount("1002", "Hari", 500);
  var acc3 = PremiumAccount("1003", "Shyam", 20000);
  var acc4 = StudentAccount("1004", "Krishna", 1000);

  // Add to bank
  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  // Interest Application
  acc1.calculateInterest();
  acc3.calculateInterest();

  // Withdrawals / Deposits
  acc1.withdraw(200);
  acc2.withdraw(600); // Overdraft
  acc4.deposit(4000);
  acc4.withdraw(1500);

  // Transfer
  bank.transfer("1001", "1002", 200);

  // Final Report
  bank.showReport();
}
