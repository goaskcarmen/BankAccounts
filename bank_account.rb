#August 23rd 2016
#  WAVE 1 REQUIREMENTS:

# Create a Bank module which will contain your Account class and any future bank account logic.
#
# Create an Account class which should have the following functionality:
#
# A new account should be created with an ID and an initial balance
# Should have a withdraw method that accepts a single parameter which represents the amount of money that will be withdrawn. This method should return the updated account balance.
# Should have a deposit method that accepts a single parameter which represents the amount of money that will be deposited. This method should return the updated account balance.
# Should be able to access the current balance of an account at any time.
# Error handling
#
# A new account cannot be created with initial negative balance - this will raise an ArgumentError (Google this)
# The withdraw method does not allow the account to go negative - Will output a warning message and return the original un-modified balance

#OPTIONAL:
#
# Create an Owner class which will store information about those who own the Accounts.
# This should have info like name and address and any other identifying information that an account owner would have.
# Add an owner property to each Account to track information about who owns the account.
# The Account can be created with an owner, OR you can create a method that will add the owner after the Account has already been created.

# WAVE 2 REQUIREMENTS:

# Update the Account class to be able to handle all of these fields from the CSV file used as input.
# For example, manually choose the data from the first line of the CSV file and ensure you can create a new instance of your Account using that data
# Add the following class methods to your existing Account class
# self.all - returns a collection of Account instances, representing all of the Accounts described in the CSV. See below for the CSV file specifications

# self.find(id) - returns an instance of Account where the value of the id field in the CSV matches the passed parameter
# CSV Data File
#
# Bank::Account
#
# The data, in order in the CSV, consists of:
# ID - (Fixnum) a unique identifier for that Account
# Balance - (Fixnum) the account balance amount, in cents (i.e., 150 would be $1.50)
# OpenDate - (Datetime) when the account was opened
#
# OPTIONAL:
#
# Implement the optional requirement from Wave 1
# Add the following class methods to your existing Owner class
#
# self.all - returns a collection of Owner instances, representing all of the Owners described in the CSV. See below for the CSV file specifications
# self.find(id) - returns an instance of Owner where the value of the id field in the CSV matches the passed parameter

# Bank::Owner
# The data, in order in the CSV, consists of:
# ID - (Fixnum) a unique identifier for that Owner
# Last Name - (String) the owner's last name
# First Name - (String) the owner's first name
# Street Addess - (String) the owner's street address
# City - (String) the owner's city
# State - (String) the owner's state
#
# To create the relationship between the accounts and the owners use the account_owners CSV file. The data for this file, in order in the CSV, consists of: Account ID - (Fixnum) a unique identifier corresponding to an account Owner ID - (Fixnum) a unique identifier corresponding to an owner

require 'CSV'

module Bank

############# ACCOUNT CLASS ###############
  class Account
    attr_accessor :balance, :id, :date

    def initialize(initial_balance, id, date)
      if initial_balance.to_i < 0
        raise ArgumentError.new("Initial balance must be greater than or equal to zero")
      end

      @balance = initial_balance
      @id = id
      @date = date
    end

#withdraw function
    def withdraw(amount)
      @balance = @balance - amount
      if @balance < 0
        puts "Sorry, your balance is less than the withdraw amount."
        @balance = @balance + amount
      end
      return @balance
    end

#deposit function
    def deposit(amount)
      @balance = @balance + amount
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
    def self.all()
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
    # @owner_account =[]
    # CSV.open("support/account_owners.csv", 'r') do |line|
    #   owner_account_hash = {}
    #   owner_account_hash.keys = Account.find(line[0])
    #   owner_account_hash.value = Owner.find(line[1])
    #   @owner_account << owner_account_hash
    # end

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

Bank::Account.createAccount
ap Bank::Account.all

ap Bank::Owner.all



######### MAIN PROGRAM ENDS #########
