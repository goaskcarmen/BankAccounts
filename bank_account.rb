#August 25th 2016
#Bank Account

require 'CSV'

module Bank

############# ACCOUNT CLASS ###############
  class Account
    attr_accessor :balance, :id, :date

    def initialize(initial_balance, id, date, min_init_balance = 0)
      if initial_balance.to_i < min_init_balance
        raise ArgumentError.new("Initial
         balance is less than the minimum allowable initial balance")
      end

      @balance = initial_balance
      @id = id
      @date = date
    end

#withdraw function
    def withdraw(amount, fee=0, limit = 0)
      @balance = balance - amount - fee
      if balance < limit
        puts "Sorry, your balance is less than the allowable withdraw amount."
        @balance = balance + amount + fee
      end
      return balance
    end

#deposit function
    def deposit(amount)
      @balance = balance + amount
      return @balance
    end

#create accounts
    def self.createAccount
      @@users = []
      CSV.open("support/accounts.csv", 'r').each do |line|
        @@users << Bank::Account.new(line[0], line[1], line[2])
      end
    end

#class method to return all the accounts
    def self.all
      return @@users
    end

#class method to return and instance of Account with the matching id
    def self.find(id)
      @@users.length.times do |i|
        if @@users[i].id == id
          return @@users[i]
        end
      end
      return nil
    end
  end
######### ACCOUNT CLASS ENDS ###########


######### SAVINGSACCOUNT CLASS ############
class SavingsAccount < Account
  def initialize(initial_balance, id, date, min_init_balanace = 10)
    super
  end

  def withdraw(amount, fee = 2, limit = 0)
      return super
  end

  def add_interest(rate)
    @balance = balance * (1 + rate/100)
    return (balance * rate/100).round(4)
  end

end
########## SAVINGSACCOUNT CLASS ENDS ###############


############ CHECKINGACCOUNT CLASS #############
class CheckingAccount < Account
  attr_reader :num_check

  def initialize(initial_balance, id, date)
    @num_check = 3
    super
  end

  def withdraw(amount, fee = 1, limit = 0)
    return super
  end

  def withdraw_using_check(amount, fee = 0, limit = -10)
    if num_check == 0
      fee = 2
    end
    @num_check -= 1

    return withdraw(amount, fee, limit)
  end

  def reset_checks
    @num_check = 3
  end
end
########### CHECKINGACCOUNT CLASS ENDS ###########


########### MONEYMARKETACCOUNT CLASS ############
class MoneyMarketAccount < SavingsAccount
  attr_reader :num_transactions

  def initialize(initial_balance, id, date, min_init_balance = 10000)
    @num_transactions = 6
    super
  end

  def money_market_withdraw(amount, fee=0, limit = 10000)
    if balance < limit
      puts "sorry, withdrawal is not allowed at this point. Please deposit."
    elsif (balance - amount) < limit && transactions != nil
      puts "Your money market account balance is now less than the limit."
      fee = 100
      return withdraw(amount, fee)
    else
      return nil
    end
  end

  def deposit(amount)
    limit = 10000
    if amount+balance >= limit
      super
    else
      transactions
      super
    end
  end

  def transactions
    if num_transactions <= 0
      puts "You are over the transaction limit. Sorry cannot perform your request."
      return nil
    end
    @num_transactions -= 1
  end

  def reset_transactions
    @transactions = 6
  end
end
############# MONEYMARKETACCOUNT CLASS ENDS ##############


############# OWNER CLASS #################
  class Owner
    attr_accessor :first_name, :last_name, :address

    def initialize(id, last_name, first_name, street, city, state)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @street = street
      @city = city
      @state = state
    end

  #This class method returns a collection of Owner instances in the CSV file
    def self.all
      @@owners = []
      CSV.open("support/owners.csv", 'r').each do |line|
        @@owners << self.new(line[0], line[2], line[3], line[4], line[5], line[6])
      end
      return @@owners
    end

  #This class method returns and instance of Owner where the id parameter matches the id of the instance
    def self.find(id)
      @@owners.length.times do |i|
        if @@owners[i].id == id
          return @@owners[i]
        end
      end
      return nil
    end

  end
########## OWNER CLASS ENDS #############


########### ACCOUNT-OWNER CLASS ##############
  class AccountOwner
    def initialize()

    end


  #return the owner with an account id parameter
    def returnOwner(account_id)
      CSV.open("support/account_owners.csv", 'r').each do |line|
        if line[0] == account_id
          return Bank::Owner.find(line[1])
        end
      end
      return nil
    end

  #return the account with an owner id parameter
    def returnAccount(owner_id)
      CSV.open("support/account_owners.csv", 'r').each do |line|
        if line[1] == owner_id
          return Bank::Account.find(line[0])
        end
      end
      return nil
    end

  end

########## ACCOUNT-OWNER CLASS ENDS ##########
end


######### MAIN PROGRAM ##########
require "awesome_print"

# Bank::Account.createAccount
# ap Bank::Account.all
# ap Bank::Owner.all

# user1 = Bank::SavingsAccount.new(50, "2345", "1/1/2016")
# puts user1.withdraw(50)
# puts user1.deposit(100)

# puts "should not be able to open an account with $5, the minimum is $10\n"
# user2 = Bank::SavingsAccount.new(5, "23342", "1/2")

# user3 = Bank::SavingsAccount.new(100, "23342", "1/2")
# puts "the result should be 48."
# puts user3.withdraw(50)
# puts "expected: insufficient fund. 48"
# puts user3.withdraw(48)
# puts "interest rate"
# puts user3.add_interest(0.25)

# user4 = Bank::CheckingAccount.new(100, "2345", "1/1/2016")
# puts "expected: 49"
# puts user4.withdraw(50)
# puts "expected: 49. insufficient fund"
# puts user4.withdraw(50)
#
# puts user4.withdraw_using_check(10)
# puts user4.withdraw_using_check(10)
# puts user4.withdraw_using_check(10)
# puts "expected: num_check exceed 3, fee $2. value 7"
# puts user4.withdraw_using_check(10)
# user4.reset_checks
# puts "expected: reset num_check to  3, fee $0. value -9"
# puts user4.withdraw_using_check(16)
#
# user5 = Bank::MoneyMarketAccount.new(10000, "4231", "142")
# puts "expect: warning that the account is less than the limit. $100 fee. value 4900"
# puts user5.money_market_withdraw(5000)
# puts "expect: withdrawal is not allow."
# puts user5.money_market_withdraw(200)
# print "num_transactions: "
# puts user5.num_transactions
# puts "deposit 500"
# puts user5.deposit(500)
# print "num_transactions: "
# puts user5.num_transactions
# puts "deposit 10000"
# puts user5.deposit(10000)
# print "num_transactions: "
# puts user5.num_transactions

######### MAIN PROGRAM ENDS #########
